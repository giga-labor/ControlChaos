# Guida Progetto (IT)

Questa guida descrive la struttura aggiornata di **Control Chaos** e il flusso di manutenzione per il repository GitHub.

## Obiettivo
Portale statico per analisi SuperEnalotto con:
- archivio storico estrazioni
- catalogo algoritmi
- pagine statistiche e informative

## Repository
- URL: `https://github.com/giga-labor/secc`
- Branch principale: `main`
- Deploy: GitHub Pages

## Struttura Principale
- `index.html`: home
- `pages/algoritmi/`: catalogo e schede algoritmo
- `pages/storico-estrazioni/`: archivio estrazioni
- `pages/analisi-statistiche/`: analisi statistiche
- `pages/privacy-policy/`, `pages/cookie-policy/`, `pages/contatti-chi-siamo/`: pagine legali
- `archives/draws/draws.csv`: dataset storico
- `data/modules-manifest.json`: sorgente card
- `data/cards-index.json`: fallback/generato
- `assets/js/version.js`: versione pubblica UI

## Flusso Card
1. Le card sono elencate in `data/modules-manifest.json`.
2. Ogni entry punta a un `card.json` locale.
3. Il frontend carica il manifest runtime.

### Aggiunta Nuovo Algoritmo
1. Crea `pages/algoritmi/<id>/`
2. Aggiungi `index.html` + `card.json` (+ `img.webp` opzionale)
3. Inserisci il path in `data/modules-manifest.json`
4. Facoltativo: rigenera fallback
```bash
python scripts/build-cards-index.py
```

## Storico Estrazioni
- File sorgente: `archives/draws/draws.csv`
- La pagina storico legge il CSV lato client e applica filtri ricerca.

## File Root Tecnici
- `ads.txt`: da compilare con publisher AdSense reale
- `robots.txt`: regole crawl
- `sitemap.xml`: elenco URL pubbliche

## Versioning
- Aggiornare `assets/js/version.js` a ogni rilascio.

## Avvio Locale
```bat
start-server.bat
```
URL locale: `http://localhost:8000/`

## Deploy GitHub Pages
1. Settings -> Pages
2. Source: Deploy from a branch
3. Branch: `main`
4. Folder: `/ (root)`

URL atteso: `https://giga-labor.github.io/secc/`

## Note Operative
- Nessun backend.
- Componenti ads nel layout sono UI interne; non equivalgono a integrazione AdSense automatica.
- Prima del go-live ads, completare `ads.txt` con `pub-...` reale.
