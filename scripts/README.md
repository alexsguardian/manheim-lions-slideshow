# Manheim Lions Slideshow - Deployment Guide

This directory contains the deployment scripts for setting up the slideshow on a Raspberry Pi.

## 📋 Prerequisites

- **Raspberry Pi 3B or newer** with Raspberry Pi OS Lite installed
- **Internet connection** during setup
- **HDMI display** (preferably vertical orientation)
- **SD card** (16GB+ recommended)

## 🚀 Quick Installation

### Option 1: One-Line Install (Recommended)

```bash
curl -fsSL https://raw.githubusercontent.com/alexsguardian/manheim-lions-slideshow/main/scripts/install.sh | bash
```

### Option 2: Manual Installation

1. **Download the installer:**
   ```bash
   wget https://raw.githubusercontent.com/alexsguardian/manheim-lions-slideshow/main/scripts/install.sh
   chmod +x install.sh
   ```

2. **Run the installer:**
   ```bash
   ./install.sh
   ```

3. **Reboot the system:**
   ```bash
   sudo reboot
   ```

## 🔧 What the Installer Does

The cloud-init style installer performs the following:

### System Configuration
- ✅ Updates all system packages
- ✅ Installs required packages (Node.js, Chromium, nginx, X11)
- ✅ Creates dedicated service user (`slideshowdisplay`)
- ✅ Configures automatic login to graphical session

### Application Setup
- ✅ Clones the project repository to `/opt/manheim-lions-slideshow`
- ✅ Installs npm dependencies and builds the application
- ✅ Configures nginx to serve the static files
- ✅ Creates systemd service for automatic startup

### Display Configuration
- ✅ Sets up Chromium in full-screen kiosk mode
- ✅ Configures vertical display rotation (90° left)
- ✅ Disables screen blanking and power management
- ✅ Hides mouse cursor for clean presentation

### Management Tools
- ✅ Creates update script (`slideshow-update`)
- ✅ Creates status monitoring script (`slideshow-status`)
- ✅ Installs `kiosk-switch` for switching between the menu and the slideshow
- ✅ Configures proper logging and error handling

## 🛠️ Post-Installation Management

### Updating the Slideshow

To update the slideshow content or application:

```bash
slideshow-update
```

This will:
- Pull the latest code from the repository
- Rebuild the application
- Restart all services
- Apply changes immediately

### Switching Between the Menu and the Slideshow

The digital menu ([manheim-lions-digimenu](https://github.com/alexsguardian/manheim-lions-digimenu)) and this slideshow can be installed on the same Pi. Switch what the TV shows with:

```bash
kiosk-switch menu        # show the food stand menu
kiosk-switch slideshow   # show the community slideshow
kiosk-switch toggle      # switch to whichever one isn't showing
kiosk-switch status      # show what's on screen and what's installed
```

Each app keeps its own nginx site; `kiosk-switch` enables one at a time and restarts the kiosk browser (the screen is blank for about 20 seconds while it reloads). The `slideshow-display` service runs the kiosk for both apps, so the menu's own `menu-display` service is masked.

**Install order:** install the digimenu first (if you want it), then this slideshow. The slideshow installer sets up the shared kiosk and disables the menu's kiosk service. Re-running the digimenu installer afterwards puts its own kiosk back in charge; re-run this installer to fix that.

To switch on a schedule, add root cron entries (`sudo crontab -e`), e.g. menu during stand hours:

```cron
0 10 * * * /usr/local/bin/kiosk-switch menu
0 20 * * * /usr/local/bin/kiosk-switch slideshow
```

### Checking System Status

```bash
slideshow-status
```

This displays:
- System information (IP, uptime, etc.)
- Service status (display service, web server)
- Application information (build time, git status)
- Access URLs for the slideshow

### Manual Service Control

```bash
# Start/stop the display service
sudo systemctl start slideshow-display
sudo systemctl stop slideshow-display
sudo systemctl restart slideshow-display

# Check service status
sudo systemctl status slideshow-display

# View service logs
journalctl -u slideshow-display -f

# Web server management
sudo systemctl restart nginx
sudo systemctl status nginx
```

## 🖥️ Display Configuration

### Automatic Display Setup

The installer automatically configures:
- **Vertical orientation** (90° rotation left)
- **Full-screen kiosk mode** with no browser UI
- **No screen blanking** or power management
- **Hidden mouse cursor** for clean presentation

### Manual Display Adjustment

If you need to change display settings:

```bash
# Check available displays
xrandr

# Rotate display (as slideshowdisplay user)
sudo -u slideshowdisplay xrandr --output HDMI-1 --rotate left

# Different rotation options:
# --rotate normal (0°)
# --rotate left (90° counterclockwise)
# --rotate right (90° clockwise)
# --rotate inverted (180°)
```

## 🌐 Network Access

After installation, the slideshow is accessible at:

- **Local (on Pi):** http://localhost/
- **Network:** http://[PI_IP_ADDRESS]/
- **Health check:** http://[PI_IP_ADDRESS]/health

To find the Pi's IP address:
```bash
hostname -I
```

## 📁 File Structure

```
/opt/manheim-lions-slideshow/          # Main application directory
├── src/                          # Source code
├── dist/                         # Built static files (served by nginx)
├── scripts/                      # Deployment scripts
└── package.json                  # Node.js dependencies

/etc/systemd/system/
└── slideshow-display.service          # Systemd service file

/etc/nginx/sites-available/
└── slideshow-display                  # Nginx configuration

/var/lib/slideshowdisplay/             # Service user home directory
└── .config/openbox/              # Window manager config

/usr/local/bin/
├── slideshow-update                   # Update script
└── slideshow-status                   # Status script
```

## 🔍 Troubleshooting

### Service Won't Start

1. **Check service status:**
   ```bash
   sudo systemctl status slideshow-display
   journalctl -u slideshow-display -n 20
   ```

2. **Verify X server is running:**
   ```bash
   ps aux | grep X
   ```

3. **Check display connection:**
   ```bash
   sudo -u slideshowdisplay DISPLAY=:0 xrandr
   ```

### Display Issues

1. **Wrong orientation:**
   ```bash
   sudo systemctl stop slideshow-display
   sudo -u slideshowdisplay DISPLAY=:0 xrandr --output HDMI-1 --rotate left
   sudo systemctl start slideshow-display
   ```

2. **Browser not starting:**
   ```bash
   # Check Chromium manually
   sudo -u slideshowdisplay DISPLAY=:0 chromium-browser --version
   ```

### Network Issues

1. **Nginx not serving content:**
   ```bash
   sudo nginx -t
   sudo systemctl status nginx
   curl http://localhost/health
   ```

2. **Application not built:**
   ```bash
   cd /opt/manheim-lions-slideshow
   sudo -u slideshowdisplay npm run build
   ```

### Performance Issues

1. **High CPU usage:**
   ```bash
   top -u slideshowdisplay
   ```

2. **Memory issues:**
   ```bash
   free -h
   sudo journalctl -u slideshow-display | grep -i memory
   ```

## 🔐 Security Notes

- The service runs as a dedicated user (`slideshowdisplay`) with minimal privileges
- Systemd security features are enabled (NoNewPrivileges, PrivateTmp, etc.)
- Nginx serves static files only with security headers
- No unnecessary network services are exposed

## 📋 System Requirements

### Minimum Requirements
- **Raspberry Pi 3B** or newer
- **1GB RAM** (2GB+ recommended)
- **16GB SD card** (Class 10 or better)
- **HDMI display** with 1920x1080 resolution

### Recommended Setup
- **Raspberry Pi 4B** with 4GB RAM
- **32GB SD card** (Class 10 or A2)
- **Fast ethernet** or 5GHz WiFi connection
- **Vertical HDMI display** for optimal slideshow viewing

## 📞 Support

For issues or questions:

1. Check the troubleshooting section above
2. Review service logs: `journalctl -u slideshow-display -f`
3. Check system status: `slideshow-status`
4. Create an issue in the GitHub repository

## 🔄 Updating This Guide

This README is automatically deployed with the application. To update:

1. Edit this file in the repository
2. Commit and push changes
3. Run `slideshow-update` on the Pi
4. Changes will be reflected immediately
