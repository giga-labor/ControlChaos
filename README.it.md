# Control Chaos

Sito statico per analisi, algoritmi e storico estrazioni SuperEnalotto.
Nessun backend: tutte le pagine sono client-side e servite come file statici.

## Repository
- GitHub: `https://github.com/giga-labor/secc`
- Branch principale: `main`
- Deploy: GitHub Pages (root `/`)

## Contenuti Attuali
- Home con moduli in evidenza e aggiornamenti progetto
- Catalogo algoritmi con pagine tecniche dedicate
- Storico estrazioni basato su `draws.csv`
- Pagina analisi statistiche (frequenze, ritardi, co-occorrenze)
- Pagine legali: Privacy, Cookie, Contatti/Chi siamo
- Rail/ticker visuali (componenti UI del progetto, non widget ad-network)

## Struttura Progetto
- `index.html`: home
- `pages/algoritmi/`: catalogo e dettaglio algoritmi
- `pages/storico-estrazioni/`: archivio storico
- `pages/analisi-statistiche/`: analisi statistiche
- `pages/privacy-policy/`: privacy policy
- `pages/cookie-policy/`: cookie policy
- `pages/contatti-chi-siamo/`: contatti/chi siamo
- `assets/`: CSS/JS/audio
- `img/`: immagini condivise
- `archives/draws/draws.csv`: dataset estrazioni
- `data/modules-manifest.json`: sorgente principale card
- `data/cards-index.json`: indice card generato/fallback
- `scripts/`: utility di manutenzione

## Flusso Card
Le card vengono caricate runtime da `data/modules-manifest.json`.
Ogni algoritmo ha il proprio `card.json`.

Per aggiungere una nuova card algoritmo:
1. Crea `pages/algoritmi/<id>/`
2. Aggiungi `index.html`, `card.json`, opzionale `img.webp`
3. Inserisci `pages/algoritmi/<id>/card.json` in `data/modules-manifest.json`
4. (Opzionale) rigenera indice fallback:
```bash
python scripts/build-cards-index.py
```

## Avvio Locale
Esegui:
```bat
start-server.bat
```
Poi apri:
- `http://localhost:8000/`

## File SEO / Crawl / Ads
In root sono presenti:
- `ads.txt` (template da completare con publisher ID AdSense reale)
- `robots.txt`
- `sitemap.xml`

Importante:
- Sostituisci la riga placeholder in `ads.txt` con il tuo `pub-...` reale prima dei controlli monetizzazione in produzione.

## Versionamento
- La versione UI e in `assets/js/version.js` (`window.CC_VERSION`).
- Incrementare la versione a ogni rilascio.

## Pubblicazione (GitHub Pages)
1. Repo -> Settings -> Pages
2. Source: Deploy from a branch
3. Branch: `main`
4. Folder: `/ (root)`

URL atteso:
- `https://giga-labor.github.io/secc/`

## Note
- L'autoplay audio e limitato dai browser; toggle audio disabilitato di default.
- Nessun backend richiesto.

## Documentazione EN
Vedi `README.md`.
