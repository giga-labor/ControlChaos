# Control Chaos

Static website for SuperEnalotto analysis, algorithms, and historical draws.
No backend: all pages are client-side and served as static files.

## Repository
- GitHub: `https://github.com/giga-labor/secc`
- Default branch: `main`
- Deploy target: GitHub Pages (`/` root)

## Current Contents
- Home with featured modules and project updates
- Algorithms catalog with dedicated technical pages
- Historical draws page backed by `draws.csv`
- Statistics page with editorial content (frequencies, delays, co-occurrences)
- Legal pages: Privacy, Cookie, Contacts/About
- Visual rails/ticker components (project UI elements, not ad-network widgets)

## Project Structure
- `index.html`: home page
- `pages/algoritmi/`: algorithms catalog and detail pages
- `pages/storico-estrazioni/`: historical draws page
- `pages/analisi-statistiche/`: statistics page
- `pages/privacy-policy/`: privacy policy
- `pages/cookie-policy/`: cookie policy
- `pages/contatti-chi-siamo/`: contacts/about
- `assets/`: CSS/JS/audio
- `img/`: shared images
- `archives/draws/draws.csv`: historical draws dataset
- `data/modules-manifest.json`: cards source of truth
- `data/cards-index.json`: generated/fallback cards index
- `scripts/`: local maintenance utilities

## Cards Flow
Cards are loaded at runtime from `data/modules-manifest.json`.
Each algorithm page has a `card.json`.

To add a new algorithm card:
1. Create `pages/algoritmi/<id>/`
2. Add `index.html`, `card.json`, optional `img.webp`
3. Add `pages/algoritmi/<id>/card.json` to `data/modules-manifest.json`
4. (Optional) refresh fallback index:
```bash
python scripts/build-cards-index.py
```

## Local Development
Run:
```bat
start-server.bat
```
Then open:
- `http://localhost:8000/`

## SEO / Crawl / Ads Readiness Files
Root files currently included:
- `ads.txt` (template to complete with your real AdSense publisher ID)
- `robots.txt`
- `sitemap.xml`

Important:
- Replace the placeholder line in `ads.txt` with your real `pub-...` before production monetization checks.

## Versioning
- UI version is exposed by `assets/js/version.js` (`window.CC_VERSION`).
- Bump version on every release batch.

## Deployment (GitHub Pages)
1. Repo -> Settings -> Pages
2. Source: Deploy from a branch
3. Branch: `main`
4. Folder: `/ (root)`

Expected site URL:
- `https://giga-labor.github.io/secc/`

## Notes
- Audio autoplay is browser-restricted; audio toggle is disabled by default.
- No backend is required.

## Italian Documentation
See `README.it.md`.
