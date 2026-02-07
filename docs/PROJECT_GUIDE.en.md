# Project Guide (EN)

This guide documents the updated **Control Chaos** architecture and maintenance workflow for the GitHub repository.

## Goal
Static SuperEnalotto analysis portal with:
- historical draws archive
- algorithms catalog
- statistics and legal/information pages

## Repository
- URL: `https://github.com/giga-labor/secc`
- Default branch: `main`
- Deployment: GitHub Pages

## Main Structure
- `index.html`: home
- `pages/algoritmi/`: algorithms catalog and detail pages
- `pages/storico-estrazioni/`: historical draws archive
- `pages/analisi-statistiche/`: statistics page
- `pages/privacy-policy/`, `pages/cookie-policy/`, `pages/contatti-chi-siamo/`: legal pages
- `archives/draws/draws.csv`: historical dataset
- `data/modules-manifest.json`: cards source of truth
- `data/cards-index.json`: generated/fallback index
- `assets/js/version.js`: public UI version

## Card Flow
1. Cards are listed in `data/modules-manifest.json`.
2. Each entry points to a local `card.json`.
3. Frontend loads the manifest at runtime.

### Add a New Algorithm
1. Create `pages/algoritmi/<id>/`
2. Add `index.html` + `card.json` (+ optional `img.webp`)
3. Add the path to `data/modules-manifest.json`
4. Optional fallback refresh:
```bash
python scripts/build-cards-index.py
```

## Historical Draws
- Source file: `archives/draws/draws.csv`
- The draws page loads CSV client-side and applies search filters.

## Root Technical Files
- `ads.txt`: must be completed with real AdSense publisher ID
- `robots.txt`: crawl directives
- `sitemap.xml`: public URL inventory

## Versioning
- Update `assets/js/version.js` for every release batch.

## Local Run
```bat
start-server.bat
```
Local URL: `http://localhost:8000/`

## GitHub Pages Deploy
1. Settings -> Pages
2. Source: Deploy from a branch
3. Branch: `main`
4. Folder: `/ (root)`

Expected URL: `https://giga-labor.github.io/secc/`

## Operational Notes
- No backend.
- Ads UI elements in the layout are project UI components; they are not automatic AdSense integration.
- Before ads go-live, complete `ads.txt` with real `pub-...` value.
