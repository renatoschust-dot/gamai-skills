---
name: gama-superbrowser
description: Jedinstveni GAMA browser/devtools tool preko CDP (Chrome/Edge). Koristi ga kad treba otvoriti sajt, pročitati stranicu, KLIKNUTI element, popuniti/poslati formu, uzeti screenshot/stream, ili pogledati console/network/perf/CSS. A11y-first (numerisani ref elementi), sa detekcijom i rješavanjem bot-checka (Cloudflare/Turnstile/DataDome) i HC fallbackom za blokirane sajtove. Triggers: "otvori sajt", "klikni na", "popuni formu", "prijavi se", "registruj se", "screenshot stranice", "pročitaj sa sajta", "devtools", "console greške", "browser".
---

# GAMA SUPERBROWSER

Jedan ulaz: `gama sbrowse <komanda> [args]` (ili `python3 $HOME/gamaos/gama_superbrowser.py ...`).
Iza sebe: Chrome/Edge preko **CDP** (`GAMACODE_CDP`, default `http://127.0.0.1:9222`), Playwright `connect_over_cdp`.

## Slojevi (best-first)
1. **a11y/DOM ref** — `snap` daje numerisane elemente (role + ime + vrijednost). Najpouzdaniji klik/type, ~10x manje tokena.
2. **CDP** — `clickt` (po tekstu), koordinate, devtools.
3. **Vision (SoM)** — kad nema ref/teksta (gama_web.web_click_vision).
4. **HC** — kad sajt blokira headless/datacenter (Turnstile 600010): pravi Chrome na kući/dispečeru + pravi miš/tastatura.

## Tabovi (izolacija)
Env `GAMACODE_TAB` (default `chat`) = ime taba. Postavlja se u `window.name`/`cdp_tabs.json`.
Npr: `GAMACODE_TAB=ag1 gama sbrowse open URL` — poseban tab, ne dira chat.

## Komande
```bash
gama sbrowse ping                      # da li CDP radi (+ verzija)
gama sbrowse tabs                      # lista otvorenih tabova
gama sbrowse open URL                  # otvori URL (+ auto botcheck rješavanje)
gama sbrowse search "upit" [engine]    # traži na Google (ili drugi engine URL)
gama sbrowse read [N]                  # tekst stranice (body)
gama sbrowse snap [maxN]               # NUMERISANI interaktivni elementi (za klik/type)
gama sbrowse click N                   # klikni element po ref broju iz snap-a
gama sbrowse clickt "tekst"            # klikni link/dugme po tekstu
gama sbrowse type N "tekst"            # ukucaj u element ref N (React-friendly)
gama sbrowse form                      # skeniraj polja forme + dugmad
gama sbrowse fill "Label=vr" "Name2=vr" [--submit]   # popuni formu po labelu/name/id/placeholder
gama sbrowse dev console|errors|perf|network|css SEL|cookies|storage|html|links
gama sbrowse frame                     # screenshot stranice (JPEG) -> /tmp/opencode/sb_frame.png
gama sbrowse botcheck                  # detekcija zaštite
gama sbrowse solve                     # pokušaj rješavanja zaštite
```

## Recept: popuni formu (preporučen tok)
1. `gama sbrowse open URL`
2. `gama sbrowse form`  → pogledaj labele/name polja
3. `gama sbrowse fill "Email=me@x.com" "Ime=Renato" "Drzava=BiH"`
4. upload fajla (biblioteka): `form_fill({...}, uploads={"CV":"/putanja/cv.pdf"})`
5. `gama sbrowse fill ... --submit` ili `gama sbrowse clickt "Pošalji"`
6. Verifikacija: `gama sbrowse read` / `gama sbrowse dev errors` / provjeri URL.

## Recept: klik "kao čovjek" kad je slijepo
1. `gama sbrowse snap` → nađi ref po imenu
2. `gama sbrowse click N`
Ako nema ref: `clickt "tekst"`. Ako ni to ne radi (canvas/JS): vision (gama_web.web_click_vision) ili HC (`gama hc <node> tap X Y`).

## Bot-check (Vercel/Cloudflare/Turnstile)
`open` automatski zove `botcheck` i `solve`. Ako `solve` ne prođe (npr. Turnstile 600010 u datacenter headless):
→ **HC fallback**: otvori na pravom Chromeu i klikni pravim mišem:
```bash
gama hc kuca open "URL"      # pravi browser na kući
gama sbrowse frame           # (ili screenshot) da vidiš stanje
gama hc kuca tap X Y         # klik koordinate
```

## Biblioteka (Python)
```python
from gama_superbrowser import snapshot, act, form_fill, read, open_, devtools, frame, solve_botcheck
s = snapshot("ag1")                 # {'elements':[{'i':1,'role':...,'name':...}, ...]}
act(3, "type", "GAMA", key="ag1")   # klik/type po refu
form_fill({"Email":"x@y.com"}, submit=True, key="ag1")
```

## Live stream
`gama sb stream-start` (server `:8899`) → otvori `http://<host>:8899/` u browseru = live kadar stranice (MJPEG), a `/frame.mjpg` možeš embedovati.

## Pravila
- Nikad ne šalji forme (submit) na pravi sajt bez izričite riječi korisnika.
- Ne diraj korisnikov aktivni tab — koristi `GAMACODE_TAB`.
- Backup prije izmjena modula: `$HOME/gamaos/gama_superbrowser.py` (radi na Contabo harness čvoru).
