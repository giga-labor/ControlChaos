$ErrorActionPreference = 'Stop'

$today = '07/02/2026'

function Ensure-MetaDescription {
  param(
    [string]$Html,
    [string]$Description
  )
  if ($Html -match '<meta\s+name="description"') {
    return $Html
  }
  $safeDescription = $Description.Replace('"', '&quot;')
  return $Html -replace '(?s)(<title>.*?</title>)', "$1`r`n  <meta name=`"description`" content=`"$safeDescription`">"
}

function Ensure-TitleTag {
  param(
    [string]$Html,
    [string]$FallbackTitle
  )
  if ($Html -match '<title>.*?</title>') {
    return $Html
  }
  $titleValue = if ([string]::IsNullOrWhiteSpace($FallbackTitle)) { 'SuperEnalotto Control Chaos' } else { $FallbackTitle }
  return $Html -replace '(<meta\s+name="description"\s+content="[^"]*">)', "<title>$titleValue</title>`r`n  `$1"
}

function Set-FileUtf8 {
  param(
    [string]$Path,
    [string]$Content
  )
  Set-Content -Path $Path -Value $Content -Encoding UTF8
}

function Update-AlgorithmPage {
  param(
    [string]$HtmlPath,
    [string]$Title,
    [string]$Subtitle,
    [string]$Summary,
    [string]$MacroLabel
  )

  $raw = Get-Content -Raw -Path $HtmlPath
  $desc = "${Title}: ${Subtitle}. Scheda tecnica con approccio, metriche, limiti e note operative."
  $raw = Ensure-MetaDescription -Html $raw -Description $desc
  $raw = Ensure-TitleTag -Html $raw -FallbackTitle "$Title - Analisi algoritmo"

  $overview = "Questa scheda descrive l approccio $Title. Focus: $Summary Metodo prevalente: area $MacroLabel, con lettura operativa dei risultati su base storica."
  $raw = $raw.Replace('Placeholder per l analisi: descrizione delle metriche chiave, note di interpretazione e affidabilita dell algoritmo.', $overview)
  $raw = $raw -replace 'Placeholder per grafico performance nel tempo\.', 'Trend temporale su finestre mobili: stabilita dello score, variazione della copertura e sensibilita ai cambi di periodo.'
  $raw = $raw -replace 'Placeholder per istogramma o boxplot\.', 'Distribuzione score e dispersione: confronto tra run omogenei per evidenziare robustezza e outlier.'
  $raw = $raw -replace 'Placeholder per tabella con combinazioni, ranking, metriche e note operative\.', 'Sintesi operativa con ranking, score normalizzato, segnali di rischio e condizioni di utilizzo responsabile.'

  $raw = $raw -replace '<p class="mt-2 text-lg font-semibold">--/--/----</p>', '<p class="mt-2 text-lg font-semibold">Aggiornamento periodico</p>'
  $raw = [regex]::Replace($raw, '(?s)(Campioni analizzati</p>\s*<p class="mt-2 text-lg font-semibold">)--(</p>)', '${1}Storico completo${2}')
  $raw = $raw -replace '<p class="mt-2 text-lg font-semibold">--%</p>', '<p class="mt-2 text-lg font-semibold">Variabile</p>'
  $raw = [regex]::Replace($raw, '(?s)(Note chiave</p>\s*<p class="mt-2 text-lg font-semibold">)--(</p>)', ('${1}Area ' + $MacroLabel + '${2}'))
  $raw = [regex]::Replace($raw, '(?s)<tbody class="divide-y divide-white/5">.*?</tbody>', @'
          <tbody class="divide-y divide-white/5">
            <tr>
              <td class="px-4 py-3 text-ash">1</td>
              <td class="px-4 py-3 text-ash">Combinazione ad alta coerenza</td>
              <td class="px-4 py-3 text-ash">Score composito</td>
              <td class="px-4 py-3 text-ash">Da validare con storico completo</td>
            </tr>
            <tr>
              <td class="px-4 py-3 text-ash">2</td>
              <td class="px-4 py-3 text-ash">Combinazione alternativa</td>
              <td class="px-4 py-3 text-ash">Score di confronto</td>
              <td class="px-4 py-3 text-ash">Uso informativo, non predittivo certo</td>
            </tr>
          </tbody>
'@)

  $raw = [regex]::Replace($raw, '(?s)<footer class="border-t border-white/10 px-6 py-6 text-center text-xs text-ash">.*?</footer>', @'
  <footer class="border-t border-white/10 px-6 py-6 text-center text-xs text-ash">
    <p>Scheda tecnica algoritmo con finalita informativa, non predittiva certa.</p>
    <div class="mt-3 flex flex-wrap items-center justify-center gap-4 text-xs uppercase tracking-[0.2em] text-ash">
      <a class="transition hover:text-neon" href="../../privacy-policy/index.html">Privacy Policy</a>
      <span class="opacity-40">|</span>
      <a class="transition hover:text-neon" href="../../cookie-policy/index.html">Cookie Policy</a>
      <span class="opacity-40">|</span>
      <a class="transition hover:text-neon" href="../../contatti-chi-siamo/index.html">Contatti / Chi siamo</a>
    </div>
  </footer>
'@)

  Set-FileUtf8 -Path $HtmlPath -Content $raw
}

function Normalize-MacroLabel {
  param([string]$Macro)
  $macroValue = if ($null -eq $Macro) { '' } else { [string]$Macro }
  $value = $macroValue.Trim().ToLowerInvariant()
  switch ($value) {
    'statistico' { return 'Statistico' }
    'statistici' { return 'Statistico' }
    'logico' { return 'Logico' }
    'logici' { return 'Logico' }
    'neurale' { return 'Neurale' }
    'ibrido' { return 'Ibrido' }
    'custom' { return 'Sperimentale' }
    default {
      if ([string]::IsNullOrWhiteSpace($value)) { return 'Sperimentale' }
      return $value.Substring(0, 1).ToUpper() + $value.Substring(1)
    }
  }
}

# Legal pages
$legalPages = @(
  'pages/privacy-policy/index.html',
  'pages/cookie-policy/index.html',
  'pages/contatti-chi-siamo/index.html'
)

foreach ($path in $legalPages) {
  $raw = Get-Content -Raw -Path $path
  $raw = $raw -replace 'Ultimo aggiornamento: \[DATA\]', "Ultimo aggiornamento: $today"
  if ($path -like '*privacy-policy*') {
    $raw = Ensure-MetaDescription -Html $raw -Description 'Informativa privacy di SuperEnalotto Control Chaos: dati trattati, finalita, servizi terzi e diritti degli utenti.'
    $raw = Ensure-TitleTag -Html $raw -FallbackTitle 'Privacy Policy - SuperEnalotto Control Chaos'
  } elseif ($path -like '*cookie-policy*') {
    $raw = Ensure-MetaDescription -Html $raw -Description 'Cookie Policy di SuperEnalotto Control Chaos: cookie tecnici, terze parti, gestione consenso e preferenze utente.'
    $raw = Ensure-TitleTag -Html $raw -FallbackTitle 'Cookie Policy - SuperEnalotto Control Chaos'
  } else {
    $raw = Ensure-MetaDescription -Html $raw -Description 'Contatti e informazioni su SuperEnalotto Control Chaos: progetto, scopo editoriale e canali di contatto.'
    $raw = Ensure-TitleTag -Html $raw -FallbackTitle 'Contatti / Chi siamo - SuperEnalotto Control Chaos'
  }
  Set-FileUtf8 -Path $path -Content $raw
}

# Home page
$homePath = 'index.html'
$homeHtml = Get-Content -Raw -Path $homePath
$homeHtml = Ensure-MetaDescription -Html $homeHtml -Description 'SuperEnalotto Control Chaos: archivio estrazioni, algoritmi di analisi e approfondimenti statistici sul dataset storico.'
$homeHtml = Ensure-TitleTag -Html $homeHtml -FallbackTitle 'SuperEnalotto Control Chaos'
$homeHtml = [regex]::Replace($homeHtml, 'Aggiungi il JSON nella cartella modulo, aggiorna il manifest.*?allestimento.?', 'Aggiungi il JSON nella cartella modulo, aggiorna il manifest e la card sara subito disponibile nel catalogo.')
$homeHtml = $homeHtml -replace 'Statistiche Superenalotto in allestimento\.', 'Analisi statistiche e modelli sperimentali su dati storici Superenalotto.'
Set-FileUtf8 -Path $homePath -Content $homeHtml

# Stats page
$statsPath = 'pages/analisi-statistiche/index.html'
$stats = Get-Content -Raw -Path $statsPath
$stats = Ensure-MetaDescription -Html $stats -Description 'Analisi statistiche SuperEnalotto: frequenze, ritardi, co-occorrenze, trend temporali e limiti interpretativi.'
$stats = Ensure-TitleTag -Html $stats -FallbackTitle 'Analisi statistiche - SuperEnalotto Control Chaos'
$stats = [regex]::Replace($stats, '(?s)<main class="content-fade.*?</main>', @'
  <main class="content-fade mx-auto max-w-5xl content-width px-6 py-16">
    <section class="rounded-3xl border border-white/10 bg-night p-8">
      <p class="text-xs uppercase tracking-[0.3em] text-ash">SuperEnalotto Control Chaos</p>
      <h1 class="mt-4 text-3xl sm:text-4xl font-semibold text-neon">Analisi statistiche del dataset storico</h1>
      <p class="mt-4 text-sm text-ash">Questa sezione riassume le letture statistiche principali costruite sullo storico estrazioni: frequenze, ritardi, co-occorrenze e stabilita temporale dei pattern.</p>
    </section>

    <section class="mt-8 grid gap-6 lg:grid-cols-3">
      <article class="rounded-3xl border border-white/10 bg-night p-6">
        <h2 class="text-lg font-semibold">Frequenze</h2>
        <p class="mt-2 text-sm text-ash">Conteggio assoluto e relativo delle uscite per numero, con confronto tra finestre temporali diverse.</p>
      </article>
      <article class="rounded-3xl border border-white/10 bg-night p-6">
        <h2 class="text-lg font-semibold">Ritardi</h2>
        <p class="mt-2 text-sm text-ash">Misura del numero di concorsi trascorsi dall ultima comparsa di ciascun numero.</p>
      </article>
      <article class="rounded-3xl border border-white/10 bg-night p-6">
        <h2 class="text-lg font-semibold">Co-occorrenze</h2>
        <p class="mt-2 text-sm text-ash">Analisi delle coppie e triple che compaiono con frequenza superiore al riferimento casuale.</p>
      </article>
    </section>

    <section class="mt-8 rounded-3xl border border-white/10 bg-night p-6">
      <h2 class="text-xl font-semibold">Metodo e limiti</h2>
      <p class="mt-3 text-sm text-ash">Le analisi hanno finalita informativa e non costituiscono previsione certa. Il gioco resta un processo aleatorio: i modelli servono a descrivere la storia dei dati, non a garantire esiti futuri.</p>
      <p class="mt-3 text-sm text-ash">Per verificare i numeri originali, consulta sempre l archivio completo delle estrazioni.</p>
      <div class="mt-5 flex flex-wrap gap-3">
        <a class="rounded-full border border-neon/70 bg-neon/10 px-4 py-2 text-sm font-semibold text-neon transition hover:-translate-y-1 hover:bg-neon/20" href="../storico-estrazioni/">Apri archivio storico</a>
        <a class="rounded-full border border-white/20 bg-white/5 px-4 py-2 text-sm font-semibold text-white/90 transition hover:-translate-y-1 hover:border-neon/70 hover:text-neon" href="../algoritmi/index.html">Vai al catalogo algoritmi</a>
      </div>
    </section>
  </main>
'@)
Set-FileUtf8 -Path $statsPath -Content $stats

# Algorithms index
$algIndexPath = 'pages/algoritmi/index.html'
$algIndex = Get-Content -Raw -Path $algIndexPath
$algIndex = Ensure-MetaDescription -Html $algIndex -Description 'Catalogo algoritmi SuperEnalotto Control Chaos: modelli statistici, logici, neurali e ibridi con schede dedicate.'
$algIndex = Ensure-TitleTag -Html $algIndex -FallbackTitle 'Algoritmi - SuperEnalotto Control Chaos'
$algIndex = [regex]::Replace($algIndex, '(?s)<footer class="border-t border-white/10 px-6 py-6 text-center text-xs text-ash">.*?</footer>', @'
  <footer class="border-t border-white/10 px-6 py-6 text-center text-xs text-ash">
    <p>Catalogo algoritmi - SuperEnalotto Control Chaos.</p>
    <div class="mt-3 flex flex-wrap items-center justify-center gap-4 text-xs uppercase tracking-[0.2em] text-ash">
      <a class="transition hover:text-neon" href="../privacy-policy/index.html">Privacy Policy</a>
      <span class="opacity-40">|</span>
      <a class="transition hover:text-neon" href="../cookie-policy/index.html">Cookie Policy</a>
      <span class="opacity-40">|</span>
      <a class="transition hover:text-neon" href="../contatti-chi-siamo/index.html">Contatti / Chi siamo</a>
    </div>
  </footer>
'@)
Set-FileUtf8 -Path $algIndexPath -Content $algIndex

# Draws page
$drawsPath = 'pages/storico-estrazioni/index.html'
$draws = Get-Content -Raw -Path $drawsPath
$draws = Ensure-MetaDescription -Html $draws -Description 'Archivio storico estrazioni SuperEnalotto con ricerca rapida per data, concorso e numeri.'
$draws = Ensure-TitleTag -Html $draws -FallbackTitle 'Storico estrazioni - SuperEnalotto Control Chaos'
Set-FileUtf8 -Path $drawsPath -Content $draws

# Algorithm pages and cards
$cardFiles = Get-ChildItem -Recurse -File -Filter card.json pages/algoritmi
foreach ($cardFile in $cardFiles) {
  $card = Get-Content -Raw -Path $cardFile.FullName | ConvertFrom-Json
  $title = [string]$card.title
  $subtitle = [string]$card.subtitle
  $summary = [string]$card.narrativeSummary
  if ([string]::IsNullOrWhiteSpace($summary)) { $summary = $subtitle }
  $macroLabel = Normalize-MacroLabel -Macro ([string]$card.macroGroup)

  $htmlPath = Join-Path $cardFile.DirectoryName 'index.html'
  if (Test-Path $htmlPath) {
    Update-AlgorithmPage -HtmlPath $htmlPath -Title $title -Subtitle $subtitle -Summary $summary -MacroLabel $macroLabel
  }

  $card.statusTag = 'Scheda tecnica'
  if ([string]::IsNullOrWhiteSpace([string]$card.lastUpdated)) {
    $card.lastUpdated = $today
  }
  Set-FileUtf8 -Path $cardFile.FullName -Content ($card | ConvertTo-Json -Depth 8)
}

# Analysis card
$analysisCardPath = 'pages/analisi-statistiche/card.json'
if (Test-Path $analysisCardPath) {
  $analysisCard = Get-Content -Raw -Path $analysisCardPath | ConvertFrom-Json
  $analysisStatusTag = if ($null -eq $analysisCard.statusTag) { '' } else { [string]$analysisCard.statusTag }
  $analysisSubtitle = if ($null -eq $analysisCard.subtitle) { '' } else { [string]$analysisCard.subtitle }
  if ($analysisStatusTag -match 'allestimento') { $analysisCard.statusTag = 'Analisi' }
  if ($analysisSubtitle -match 'allestimento') {
    $analysisCard.subtitle = 'Report statistici su frequenze, ritardi e pattern storici'
  }
  Set-FileUtf8 -Path $analysisCardPath -Content ($analysisCard | ConvertTo-Json -Depth 8)
}

# Root files
$adsTxt = @'
# ads.txt for SuperEnalotto Control Chaos
# Inserisci il tuo publisher ID AdSense reale prima della richiesta definitiva.
# Formato richiesto: google.com, pub-XXXXXXXXXXXXXXXX, DIRECT, f08c47fec0942fa0
# Esempio (non attivo finche non sostituisci X):
# google.com, pub-XXXXXXXXXXXXXXXX, DIRECT, f08c47fec0942fa0
'@
Set-FileUtf8 -Path 'ads.txt' -Content $adsTxt

$robotsTxt = @'
User-agent: *
Allow: /

Sitemap: https://giga-labor.github.io/secc/sitemap.xml
'@
Set-FileUtf8 -Path 'robots.txt' -Content $robotsTxt

$indexFiles = Get-ChildItem -Recurse -File -Filter index.html
$urls = foreach ($file in $indexFiles) {
  $rel = $file.FullName.Substring((Get-Location).Path.Length + 1).Replace('\', '/')
  if ($rel -eq 'index.html') {
    'https://giga-labor.github.io/secc/'
  } else {
    'https://giga-labor.github.io/secc/' + ($rel -replace '/index\.html$', '/')
  }
}
$uniqueUrls = $urls | Sort-Object -Unique
$sitemapLines = @(
  '<?xml version="1.0" encoding="UTF-8"?>',
  '<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">'
)
foreach ($url in $uniqueUrls) {
  $sitemapLines += "  <url><loc>$url</loc></url>"
}
$sitemapLines += '</urlset>'
Set-FileUtf8 -Path 'sitemap.xml' -Content ($sitemapLines -join "`r`n")

# Version bump
$versionPath = 'assets/js/version.js'
$versionRaw = Get-Content -Raw -Path $versionPath
if ($versionRaw -match "window\.CC_VERSION = '([0-9]+)\.([0-9]+)\.([0-9]+)';") {
  $major = [int]$matches[1]
  $minor = [int]$matches[2]
  $patch = [int]$matches[3] + 1
  $newVersion = '{0:D2}.{1:D2}.{2:D3}' -f $major, $minor, $patch
  $versionRaw = $versionRaw -replace "window\.CC_VERSION = '[0-9]+\.[0-9]+\.[0-9]+';", "window.CC_VERSION = '$newVersion';"
  Set-FileUtf8 -Path $versionPath -Content $versionRaw
}
