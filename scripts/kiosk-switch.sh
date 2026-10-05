#!/bin/bash

# Manheim Lions Kiosk Switch
# Switches the Pi between the digital menu and the slideshow.
#
# Both apps are installed side by side and each has its own nginx site.
# Only one site is enabled at a time; the slideshow-display service runs
# the (shared) Chromium kiosk pointed at http://localhost/, so switching
# is: swap the enabled nginx site, reload nginx, restart the kiosk.
#
# Usage: kiosk-switch [menu|slideshow|toggle|status]

set -euo pipefail

readonly SITES_AVAILABLE="/etc/nginx/sites-available"
readonly SITES_ENABLED="/etc/nginx/sites-enabled"
readonly KIOSK_SERVICE="slideshow-display.service"
readonly MENU_SERVICE="menu-display.service"

declare -A SITE=(
    [menu]="menu-display"
    [slideshow]="slideshow-display"
)

usage() {
    echo "Usage: kiosk-switch [menu|slideshow|toggle|status]"
    echo ""
    echo "  menu       Show the food stand digital menu"
    echo "  slideshow  Show the Lions community slideshow"
    echo "  toggle     Switch to whichever one is not showing"
    echo "  status     Show what is currently displayed"
}

current() {
    for name in "${!SITE[@]}"; do
        if [[ -L "$SITES_ENABLED/${SITE[$name]}" ]]; then
            echo "$name"
            return
        fi
    done
    echo "none"
}

status() {
    echo "🦁 Manheim Lions Kiosk"
    echo "  Showing: $(current)"
    for name in menu slideshow; do
        if [[ -f "$SITES_AVAILABLE/${SITE[$name]}" ]]; then
            echo "  $name: installed"
        else
            echo "  $name: not installed"
        fi
    done
    echo "  Kiosk service: $(systemctl is-active "$KIOSK_SERVICE" 2>/dev/null || true)"
}

switch_to() {
    local target="$1"
    local site="${SITE[$target]}"

    if [[ ! -f "$SITES_AVAILABLE/$site" ]]; then
        echo "❌ The $target is not installed (missing $SITES_AVAILABLE/$site)." >&2
        exit 1
    fi

    if ! systemctl cat "$KIOSK_SERVICE" &>/dev/null; then
        echo "❌ $KIOSK_SERVICE not found. Run the slideshow install.sh first." >&2
        exit 1
    fi

    # The menu's own kiosk service would fight ours over Chromium and the
    # display, so keep it off. It's masked so menu-update can't restart it;
    # mask can't replace a unit file in /etc, so remove that first.
    if [[ -f "/etc/systemd/system/$MENU_SERVICE" ]]; then
        systemctl disable --now "$MENU_SERVICE" &>/dev/null || true
        rm -f "/etc/systemd/system/$MENU_SERVICE"
        systemctl daemon-reload
        systemctl mask "$MENU_SERVICE"
    fi

    local previous
    previous="$(current)"

    if [[ "$previous" == "$target" ]]; then
        echo "Already showing the $target."
        return
    fi

    echo "Switching kiosk to the $target..."

    # Both sites listen as the port 80 default_server, so only one may be enabled
    for name in "${!SITE[@]}"; do
        rm -f "$SITES_ENABLED/${SITE[$name]}"
    done
    ln -s "$SITES_AVAILABLE/$site" "$SITES_ENABLED/$site"

    if ! nginx -t &>/dev/null; then
        echo "❌ nginx config test failed, rolling back." >&2
        rm -f "$SITES_ENABLED/$site"
        if [[ "$previous" != "none" ]]; then
            ln -s "$SITES_AVAILABLE/${SITE[$previous]}" "$SITES_ENABLED/${SITE[$previous]}"
        fi
        nginx -t
        exit 1
    fi

    systemctl reload nginx

    # Restart the kiosk so Chromium loads the new page (blank for ~20s)
    systemctl restart "$KIOSK_SERVICE"

    echo "✅ Now showing the $target."
}

# Needs root for nginx and systemd
if [[ $EUID -ne 0 ]]; then
    exec sudo "$0" "$@"
fi

case "${1:-}" in
    menu | slideshow)
        switch_to "$1"
        ;;
    toggle)
        if [[ "$(current)" == "slideshow" ]]; then
            switch_to menu
        else
            switch_to slideshow
        fi
        ;;
    status)
        status
        ;;
    *)
        usage
        exit 1
        ;;
esac
