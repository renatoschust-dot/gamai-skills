---
name: gama-ponuda-workflow
description: Use when the user asks to generate a quotation/offer/ponuda for GAMA TRADE, create a price quote, send a commercial offer to a customer, or prepare a proforma invoice. Also use when the user mentions generating a ponuda, creating an offer, or sending a price quote for GAMA TRADE products.
---

# GAMA TRADE — Ponuda Workflow

## ⚠️ LOKACIJE — JEDINSTVENE (korigovano iz history, nemoj koristiti "Korisnik")
- **Radni direktorij**: `$env:TEMP\gama_offer\` → realno `C:\Users\User\AppData\Local\Temp\gama_offer\`
- **Generator**: `$env:TEMP\gama_offer\generisi-ponudu.ps1`
- **Template**: `$env:TEMP\gama_offer\template-ponuda.html`
- **Šifrarnik**: `$env:TEMP\gama_offer\sifrarnik.json` (SINHRONIZOVAN sa `D:\ai\sifrarnik_baza\sifrarnik.json` — isti fajl, 1.2MB)
- **Slike artikala**: `$env:TEMP\gama_offer\slike\` i `D:\ai\sifrarnik_baza\slike\{brand}\`
- **Kupci**: `$env:TEMP\gama_offer\kupci.json` (745 kupaca) + `kupci_cache.json` + SQL baza (mp2023/mp2024/vp2026, server <node-ip> ili .\SQLEXPRESS)
- **Katalozi (odvojeni od glavnog šifrarnika!)**: `D:\ai\comprag_contracor\comprag_contracor_katalog.json`, `mat_parsed.json`, `artikli_mp2026.json`
- **Kopiranje na Desktop**: `C:\Users\User\Desktop\` (NIKAD "Korisnik")

> **NAUČENO IZ HISTORY:** Stari uputi koriste `C:\Users\Korisnik\...` što NE postoji. Ubijedljivo radno stanje je pod korisnikom **`User`**. Uvijek provjeri sa `Test-Path` i koristi ono što stvarno postoji.

## Workflow

### FAST PATH (najbrze)
- Ulaz = PDF dobavljaca ili slika PDF stranice.
- Prvo pokusaj direktni parse PDF-a, bez HTML-a i bez browsera.
- Ako je PDF tekstualan: izvuci tekst + tabele direktno u JSON.
- Ako je sken: koristi `gama_vision.py` samo za OCR/vision, pa odmah u JSON.
- JSON se onda mapira na ponudu i renderuje direktno u PDF.
- HTML koristi samo kao fallback kad direktni PDF render ne moze da pokrije layout.

### Preporuceni redoslijed
1. `PDF -> extract/text/OCR -> JSON`
2. `JSON -> ponuda model`
3. `ponuda model -> direktni PDF render`
4. `HTML fallback` samo ako je potrebno za kompleksan layout ili slike

### Pravila za brzinu
- Bez generisanja medju-HTML-a.
- Bez otvaranja browsera osim za fallback.
- Bez dodatnih kopija fajlova osim finalnog PDF-a.
- Bez ponovnog parsiranja ako je isti PDF vec obradjen u istoj sesiji.

### 1. Parsiraj zahtjev
- Ko je kupac? (naziv, JIB, adresa, telefon)
- Koji artikli? (šifra, količina, custom opis ako treba)
- Posebni uslovi? (rok plaćanja, rok isporuke, banke)

### 2. Provjeri artikle u šifrarniku / katalogu
```powershell
# Šifrarnik je NIZ objekata (ne objekat sa .artikli)!
$s = Get-Content "$env:TEMP\gama_offer\sifrarnik.json" -Encoding UTF8 | ConvertFrom-Json
$s | Where-Object { $_.sifra -eq "7712500" } | Select-Object sifra, naziv, mpc, vpc, jm, opis
```
> **VAŽNO:** Artikal koji nije u glavnom šifrarniku (Comprag/Contracor/Eurospray katalog) → generator prazne vrijednosti. Tada artikal predaj **inline u configu** sa `naziv`, `vpc`, `opis`, `kolicina` (vidi dolje). Drži katalog posebno: `D:\ai\comprag_contracor\...`.

### 3. Kreiraj config JSON (`$env:TEMP\gama_offer\ponuda-{broj}-{godina}.json`)
```json
{
  "broj": "001/2026",
  "datum": "30.07.2026.",
  "rokPlacanja": "Avans",
  "rokIsporuke": "30 dana",
  "kupac": { "naziv": "...", "adresa": "...", "telefon": "...", "idbroj": "...", "konto": "211054" },
  "stavke": [
    { "sifra": "7712500", "kolicina": 1, "vpc": 310, "naziv": "Crijevo visokotlacno 3/8...", "jm": "kom", "opis": "Spec1: vrijednost\nSpec2: x" }
  ]
}
```
- **Inline `vpc` + `naziv` у stavci OVERRIDE-UJU šifrarnik** → koristi kad kupac traži cijenu različitu od VPC (npr. 310 umjesto 300).
- `opis` je opcionalan; ako postoji, **override-uje** opis iz šifrarnika. `Key: vrijednost` linije postaju specs tabela.
- **"bez opisa"**: NE šalji `opis` ni u config ni u stavku → generator neće ispisati detail-red (vidi pravilo niže).

### 4. Generiši HTML
```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File "$env:TEMP\gama_offer\generisi-ponudu.ps1" -ConfigFile "$env:TEMP\gama_offer\ponuda-{broj}.json"
```
> Generator sam uzima `template-ponuda.html`, `sifrarnik.json`, `slike\` iz svog foldera (default `$ScriptHome`). Ne moraš slati `-TemplateFile/-SifrarnikFile` osim ako je drugačije.

### 5. Cijena — prioritet (naučeno iz history)
Generator računa: **inline `vpc` (config) > `cijena` (sifrarnik) > `vpc` (sifrarnik) > 0**.
- Cijena kolona = cijena **bez PDV** (VPC). PDV 17% se dodaje zasebno.
- Ako artikal nema MPC/VPC → "na upit".
- Ako kupac da cijenu "X KM + PDV" → to je cijena bez PDV; stavi je kao `vpc` inline.

### 6. Obavezni post-processing (NAJVAŽNIJE — kroz history se ovo najviše gubilo)
- **Garancija** (OBAVEZNO): generator hardkodira `"Garancija: 12 mjeseci."` → **u HTML-u zamijeni u `"Garancija: 3 godine."`** (ako korisnik ne traži drugačije; ako traži "bez garancije" → ukloni cijeli tekst garancije).
- **Detail-red**: ako je stavka "bez opisa" (nema `opis`) → **NE smije** ispisivati `<div class="item-desc">` sa ponovljenim nazivom. Provjeri u generisanom HTML-u da nema duplog naziva.
- **Slike**: artikl sa slikom (`$env:TEMP\gama_offer\{sifra}.jpg/.png` ili šifrarnik putanja) → ugradi base64 ili `file:///` putanju kao `<img>` u `.detail-cell` (pored opisa, float right). Obična slika preko `file:///C:/Users/User/AppData/Local/Temp/gama_offer/{sifra}.jpg` je OK za PDF.
- **Banke**: default ASA `1340011120678906`, BBI `1414155320018793`. Ako kupac traži drugu (npr. **TRABUS 1540011120678903**) → zamijeni u footer `bank-footer`. UVIJEK provjeri sa klijentom koja banka ide.
- **Footer**: kompanija info GAMA TRADE DOO (ID broj 4218981800001, PDV broj 218981800001, registracija) u desnom zaobljenom kvadraticu; social ikone (FB, IG, IN, YT, TK, OLX, PI, Viber, WA, Mail).
- **Social ikone na PONUDI = OBAVEZNE** (uvijek, svih 12: Web, FB, IG, IN, YT, TK, OLX, Novosti, Viber, WA, Mail, Lokacija — vidi `ponuda-252-2026.html`). Na ostalim dokumentima (predračun, račun, narudžba, otpremnica) social ikone mogu ali i ne moraju — nije obavezno.
- **UTF-8 / slova**: provjeri da č,ć,š,ž,đ nisu korumpirani (znak `?`). Koristi `WriteAllText` UTF8 i `<meta charset="UTF-8">`.
- **Edge cache**: **uvijek obriši stari `.pdf` prije regeneracije** (`Remove-Item`), inače Edge vrati stari fajl.
- **"Slovima"** format: `Slovima: {broj} i {ii}/100 KM` (generiše skripta, ne mijenjaj rukom).

### 7. Generiši PDF
```powershell
$edge = (Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\msedge.exe").'(default)'
Remove-Item "$env:TEMP\gama_offer\ponuda-{broj}.pdf" -ErrorAction SilentlyContinue
& $edge --headless --print-to-pdf="$env:TEMP\gama_offer\ponuda-{broj}.pdf" --no-margins --print-to-pdf-no-header "file:///C:/Users/User/AppData/Local/Temp/gama_offer/ponuda-{broj}.html"
```

### 8. Kopiraj na Desktop
```powershell
Copy-Item "$env:TEMP\gama_offer\ponuda-{broj}.html" "C:\Users\User\Desktop\"
Copy-Item "$env:TEMP\gama_offer\ponuda-{broj}.pdf"  "C:\Users\User\Desktop\"
```

### 9. Email (opciono)
```powershell
& "$env:TEMP\gama_offer\send-mail.ps1" -to "email@kupca.ba" -subject "Ponuda {broj}" -body "Postovani,..." -attach "$env:TEMP\gama_offer\ponuda-{broj}.pdf"
```

## RABAT U PONUDI (NAUČENO 12.08.2026.)
- Procenat rabata se unosi **po stavci** u config, polje `"rabat": N` (broj = %). Ako je 0 → računa nulu.
- Generator računa i prikazuje **ukupan rabat** u zaglavlju ukupnih (desni `right-col`) kao red **`Iznos rabata`**, između `Prodajna vrijednost` i `Ukupan iznos bez PDV`.
- Formule: `Prodajna vrijednost` = ZBROJ bruto (prije rabata); `Iznos rabata` = ZBROJ (bruto × rabat%); `Ukupan bez PDV` = Prodajna − Rabat; PDV/sa PDV od `Ukupan bez PDV`.
- Primjer config: `{ "sifra":"XHD417", "kolicina":3, "rabat":10, "opis":"..." }`
- **Redoslijed u right-col** (standard "kako se rade ponude"): `Prodajna vrijednost` → `Iznos rabata` → `Ukupan iznos bez PDV` → `Ukupan iznos PDV (17%)` → `Ukupan iznos sa PDV`.
- Generator već računa `bezPdv = bruto − rabatI` po stavci; `$ukupnoBruto` i `$ukupnoRabat` se sabiraju za Prodajna/Iznos rabata (dodato u `generisi-ponudu.ps1` linije ~97-126 i ~256-279).

## PDV STANDARD (NAUČENO 12.08.2026.)
- **Standard ponuda ide SA PDV** (kupac plaća prodajnu cijenu sa PDV). Cijene u šifrarniku/SQL su VPC (**bez PDV**); tabela prikazuje i "bez PDV" i "sa PDV", sa ukupnim sa PDV istaknutim (grand).
- **Izuzeci**: ako kupac izričito traži ponudu BEZ PDV (npr. GRADING-KGM d.o.o.) → ponudu dati bez PDV naglaska, ali to je poseban slučaj, ne standard.
- Ne mijenjati VPC vrijednosti; samo način prikaza/zahtjev kupca.

## TEHNIČKE SPECIFIKACIJE — PRIORITET (OBAVEZNO, iz history)
Za `opis` u stavkama koristi strogo ovaj prioritet izvora, i **NIKAD ne stavljaj web poveznice (URL) u ponudu/opis**:
1. **SQL baza `mat`** (`SELECT sifmat,nazivmat FROM mat WHERE sifmat='...'`; sve baze vp2026→…→mp2024) — često kratak naziv, ali je sistem.
2. **Lokalna AI baza/katalozi**: `D:\ai\katalog_cjenovnici\master_cjenovnik.json` (94k, `naziv` ima pune spec), `graco.json`/`graco_emea.json` (zvanični Graco nazivi npr. "KING SPRAYER,70:1,H-P,BF,HD,COMP", "XHD RAC TIP,SPRAY,CYLINDER,417"), `sifrarnik.json`, `comprag_contracor_katalog.json` (opisi NA BOSANSKOM).
3. **Web** (graco.com, airblast.com...) — ZADNJA opcija; služi samo kao izvor podataka (skini sliku/opis), bez poveznica.
- Bogat opis u config: `opis: "Vizuelni opis.\n\nSpec1: vrijednost\nSpec2: vrijednost"` → `Key: Value` linije postaju `<table class="specs">`.
- Primjer (Graco): kataloški kod proširiti u razumljiv bosanski opis i spec tabelu.

## SLIKE U PONUDI
- **Za sada ponude idu BEZ slika artikala** (lokalne slike su često generičke/pogrešne — npr. svi Graco pokazuju na jedan fajl `0104781_easymax...`). Ako korisnik traži slike → preuzmi tačne sa graco.com/airblast.com i ugradi base64; ne koristi placeholder/generičke.

## FOOTER (ispravni izvor — NAUČENO 12.08.2026.)
- **Trenutni `template-ponuda.html` NEMA ispravan footer** (samo bank podatke, bez social ikona). Ispravan kompletan footer (bank + 12 social ikona: Web, FB, IG, IN, YT, TK, OLX, Novosti, Viber, WA, Mail, Lokacija) nalazi se u **`ponuda-252-2026.html`**.
- **NAKON SVAKE REGENERACIJE generatora** obavezno ponovo primijeni post-processing:
  1. `Garancija: 12 mjeseci` → `Garancija: 1 godina` (ili "3 godine" po zahtjevu)
  2. Zamijeni cijeli `<div class="fixed-footer">` blok sa onim iz `ponuda-252-2026.html` (bank-footer sa ID/ASA/BBI + "Gama Trade d.o.o. Zabljak bb | Tel: +387 32 891 555 | info@gamatrade.ba" + social ikone).
- Banke default: ASA `1340011120678906`, BBI `1414155320018793` (uvijek provjeriti sa klijentom).

## Višestrana ponuda (A4, page 1/2/3)
- Header i footer ostaju **isti na svakoj strani**.
- Ukupan iznos (Prodajna vrijednost / PDV / **sa PDV**) i potpis idu **tek na kraju svih artikala** (na zadnoj strani ako ne stane).
- `table.items` ima `page-break-inside: avoid` po tbody — artikli se ne lome kroz stranicu.

## Ugrađivanje slike (base64 / file)
```powershell
# Najjednostavnije: file:/// putanja radi u Edge headless PDF-u
<img src="file:///C:/Users/User/AppData/Local/Temp/gama_offer/{sifra}.jpg">
# Ili base64 za neovisnost o putanji:
$bytes = [IO.File]::ReadAllBytes("D:\ai\sifrarnik_baza\slike\$brand\$slika.jpg")
$b64 = [Convert]::ToBase64String($bytes)
$imgHtml = '<div class="product-img"><img src="data:image/jpeg;base64,' + $b64 + '" style="width:100%;display:block;"></div>'
# Ubaci u .detail-cell prije </td>
```

## Napomene
- Cijene su **bez PDV** (VPC iz šifrarnika). PDV 17% se dodaje posebno.
- Ako artikal nema MPC/VPC → "na upit".
- `opis` u stavci override-uje opis iz šifrarnika; **"bez opisa"** → izostavi opis i detail-red.
- Comprag/Contracor/Eurospray artikli: **nisu u glavnom šifrarniku** → koristi katalog + predaj inline (`naziv`/`vpc`/`opis`) u config. Prodajne cijene su često više od SQL VPC.
- **Broj ponude**: kontinuirana sekvenca. Provjeri zadnji postojeći `.json`/`.html` u `$env:TEMP\gama_offer\` (npr. 369/2026 → sljedeći 370/2026). Formati `nnn/yyyy` ili `nnn/yy`.

## 🔄 VEZA SA ERP-OM I BAZOM
- Ponuda se povezuje sa `pfkalk` u SQL bazi (`vp2026` na <node-ip>, ili `mp2023`/`mp2024` prema kontekstu) sa **`ponuda=1`**.
- Otpremnica → `otpremnica=1`; narudžbenica → **`nar=1`** (šifra `narudzbenica`/`nar` po shemi).
- Račun → `pfkalk`/`pfstavke` sa `fiskalni=1`; XML ide u `\<node-ip>\Tring\xml\` kao **jedna stavka**: "Promet po fakturi:{brkalk}" sa ukupnom cijenom SA PDV.
- Razduženje robe u `pfkalk` sa `ponuda=1` i **cijenom = VPC** (nikad nabavnom).
- Kalkulacija ulaza robe koristi `vkalk`/`vstavke`, NE `kalk`/`kustavke`.

## Narudžbenice (iz PDF ponude dobavljača)
- Skripta: `generisi-narudzbenicu.ps1` — `-PdfFile "Ponuda_XXXX.pdf" -Broj "78-26" -Datum "06.08.2026." -Dobavljac "..." -Oib "..." -VasPonuda "1370-2026" -Kontakt "..."`.
- **Narudžbenica NE sadrži "Rok isporuke"/"Placanje"** — samo veza `Vasa ponuda: XXXX-2026` (desni info-box). `-RokIsporuke/-Placanje` se NE šalju.
- Zaglavlje → `pfkalk` sa `nar=1`, `ponuda=0`, `avans=0`, `gotovina=0`, `sifval='KM'`.

## Računi
- Skripte: `export-racuni.ps1` / `export-racuni-frx.ps1` / `export-racun-frx.ps1`.
- Koriste isti `template-ponuda.html` ali sa **RACUN** naslovom.

## Parsiranje PDF-ova dobavljača
- `pdftotext -layout` (D:\ai\poppler\poppler-24.08.0\Library\bin) za tekstualne PDF.
- `Tesseract OCR` za skenirane — **samo eng jezik** (š/č/ć se iskrivljava ASCII, provjeri ručno).
- Parsirane stavke se učitavaju u šifrarnik.

## Audit / log
- Sve generisane ponude, narudžbenice i računi se automatski loguju u `D:\ai\chat_historija\sesije\` (session .txt) + `index.json` za ponovno korištenje.
