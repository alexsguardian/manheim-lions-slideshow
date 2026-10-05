# Manheim Lions Slideshow

A self-advancing kiosk slideshow (built with Astro) showing what the [Manheim Lions Club](https://manheimlions.org) does for the community. It runs on the TV at the club's Farm Show food stand, alongside the [digital menu](https://github.com/alexsguardian/manheim-lions-digimenu): a Raspberry Pi boots into Chromium kiosk mode and displays this page.

<p align="center">
  <img src="docs/preview.webp" alt="Slideshow preview showing the Santa 5K Run & Walk slide" width="320" />
</p>

Laid out for a vertical (portrait) TV. The page is locked to a 9:16 frame, so on a landscape screen it shows centered with black bars, matching what the kiosk displays.

## Editing slides

All slides live in `src/data/slides.ts`. Each slide has a kicker, title, body, and optional image (`fit: 'cover'` for photos, `'contain'` for posters/illustrations). A slide with no image shows the large QR code.

Images live in `public/slides/` and are referenced with relative paths (`./slides/name.webp`) so the built page works from any path, including opening `dist/index.html` directly. They come from the Manheim Lions Club website and are resized to fit within 1200px. Resize new images similarly before adding them, since a Pi has to decode them.

Slides advance every 12 seconds by default (override per slide with `duration`). For testing, click or use the arrow keys / space to move between slides, or add `?slide=N` to the URL to jump to a slide.

## Commands

| Command           | Action                                       |
| :---------------- | :------------------------------------------- |
| `npm install`     | Installs dependencies                        |
| `npm run dev`     | Starts local dev server at `localhost:4321`  |
| `npm run build`   | Build your production site to `./dist/`      |
| `npm run preview` | Preview your build locally, before deploying |

## Deploying to a Raspberry Pi

See [`scripts/README.md`](scripts/README.md) for the Pi installer, management commands, and `kiosk-switch`, which switches the TV between the digital menu and this slideshow.

## License

The source code is licensed under the [MIT License](LICENSE).

The images, logos, and slide text belong to the Manheim Lions Club and are **not** covered by the MIT License. The Lions emblem is a registered trademark of Lions Clubs International. If you fork this project for your own club, replace them with your own content.
