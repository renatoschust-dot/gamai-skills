---
name: gama-hc-harness
description: Human Compute (HC) automation harness — deterministički upravlja računarom (klik, kucanje, čitanje ekrana) preko UI Automation prvo, pa koordinate, pa OCR. Svaka akcija ima verifikaciju (dokaz: hash + screenshot). Koristi YAML tokove (rute) kao eksplicitan graf. Aktivira se na "HC harness", "automatizuj aplikaciju", "deterministička ruta", "uđi u aplikaciju", "popuni formu", "klikni kucaj", "gama-hc", "harness rutu", "PostIS unos", "KASA automatizacija".
---

# GAMA HC HARNESS

Deterministički sloj iznad Human Compute: **UIA prvo** (semantički, 10–50 ms), **koordinate** (keširane) kao drugi izbor, **OCR** (vizuelni) kao zadnji. **Svaka akcija ima verifikaciju** (dokaz). Tok je **eksplicitan graf** (YAML), ne pogađanje.

> Izvor: ChatGPT + Perplexity + naši eksperti (arhitekta, code, reason, tehnicar, plan, researcher, review) — konsenzus arhitekture 23.09.2026.

## 1. PRINCIP (nepromjenjiv)
```
Redoslijed pouzdanosti — FIKSAN i deterministički:
  UIA (semantički)  →  koordinate (keširane)  →  OCR (vizuelni)

Svaka akcija = transakcija:
  resolve(target) → act() → verify(predicate) → [retry | fallback]

Dokaz poslije svake akcije: screenshot hash + (ako treba) text/title.
Koordinate NIKAD primarne — samo fallback.
```

## 2. ARHITEKTURA
```
gama_hc_harness/
  state.py    — screen-state cache: screenshot hash + UIA tree + fokus + bounds
  resolve.py  — locator: UIA → koordinate → OCR (fiksni redoslijed)
  actions.py  — atomične akcije: CLICK / TYPE / KEY / WAIT / ASSERT / SCROLL / DRAG
  compile.py  — YAML flow → deterministički graf (validacija + topološki red)
  run.py      — executor: akcija → verify → retry/fallback → log (JSON)
  flows/      — determinističke rute (YAML): login.yaml, unos_kupca.yaml, ...
```

**Komponente (sve hashabilno i ponovljivo):**
| Komponenta | Radi |
|---|---|
| **UIA adapter** | `pywinauto` — traži kontrolu po `automation_id`/`role`/`name` (ne OCR) |
| **Screen-state cache** | hash ekrana + UIA tree; invalidira se poslije akcije koja mijenja stanje |
| **Verifier** | `exists("Save")`, `text("#status")=="Done"`, window title |
| **Retry engine** | bounded, deterministički: UIA → koordinate → OCR |
| **Action graph** | immutabilni čvorovi: action, verify, retry, fallback, timeout |
| **Safety** | allowlist aplikacija/akcija; potvrda za destruktivno |

## 3. GAMA L DSL (za LLM generator akcija)
```
CLICK target            # target: "#submit" | "Save" | point(x,y)
TYPE "tekst"
KEY Ctrl+S
WAIT 100ms
SCROLL down 3
SCREENSHOT
ASSERT exists("Save")
ASSERT text("#status") == "Complete"

ACTION submit:
  DO CLICK "#submit"
  VERIFY exists("#success")
  RETRY 2
  FALLBACK CLICK point(840,620)
  TIMEOUT 3000
```

**Podjela posla (ključno):**
- **LLM** generiše: *namjeru + selektore + verify predikate*
- **Lokalni deterministički engine** odlučuje: *izvršenje, retry, fallback*
→ 99% pouzdanost je **mjerljiva**, ne zavisi od raspoloženja modela.

## 4. YAML RUTA (primjer — deterministički graf)
```yaml
# flows/unos_kupca.yaml
name: unos_kupca
app: "PostIS"                 # allowlist
steps:
  - id: login
    do:   CLICK "#username"
    type: "{{konto}}"
    verify: exists("#password")
  - id: pass
    do:   CLICK "#password"
    type: "{{pin}}"
    verify: exists("#login_btn")
  - id: enter
    do:   CLICK "#login_btn"
    verify: window "Nalozi za prikup"
  - id: kupac
    do:   CLICK "#P13_ADSR_ID_lov_btn"
    verify: exists("#lov_search")
    fallback: KEY F5
```
Parametri (`{{konto}}`, `{{pin}}`) — iz naših alata (SQL/tajne), nikad hardkodovani.

## 5. INTEGRACIJA SA NAŠIM ALATIMA (obavezno)
| Naš alat | Kako harness to koristi |
|---|---|
| **HC daemon (:7100)** | izvršava atomične akcije na ciljnoj mašini (`tap`, `type`, `key`, `find`, `uiact`) |
| **Skillovi** | ruta poziva skill za domenu (npr. `gama-logistika` za PostIS) |
| **SQL (the ERP database)** | parametri rute (kupac, artikal, cijena) — konto/matbroj |
| **Tajne** | `{{pin}}` iz `.gama_api_keys.env`, nikad u YAML-u |
| **Filesystem** | logovi (JSON) + screenshot dokazi u `logs/<flow>/<run>/` |
| **Verifikacija** | `verification-before-completion` skill — dokaz prije "gotovo" |

## 6. KAKO SE POKREĆE
```bash
# jedan flow na ciljnoj mašini
python gama_hc_harness/run.py flows/unos_kupca.yaml --host podrum --params '{"konto":"2111176"}'

# bench (mjeri latenciju/uspjeh)
python gama_hc_harness/run.py --bench

# iz GAMACODE motora
POST /v1/hc-ruta {"flow":"unos_kupca","host":"podrum","params":{...}}
```

## 7. CILJEVI (mjerljivi)
| Metrika | Cilj |
|---|---|
| latencija/akcija | **≤ 200 ms** (UIA) |
| pouzdanost | **≥ 99%** (verifikovane akcije) |
| dokaz | 100% akcija ima hash + screenshot |
| determinizam | isti ulaz + isto stanje → isti tok |

## 8. PRAVILA
- **UIA prvo** — koordinate/OCR samo fallback.
- **Koordinate se keširaju** uz UIA element (bounds), nikad "iz glave".
- **Svaka akcija verifikovana** — nema naredne bez potvrde prethodne.
- **Allowlist** aplikacija; destruktivno traži potvrdu.
- **NIKAD** ne mijenjati podatke kupca bez eksplicitne naredbe; read-only gdje god može.
- Log + dokaz obavezni (JSON + PNG).

---
*Napravljeno iz konsenzusa: ChatGPT + Perplexity + naši eksperti (arhitekta/code/reason/tehnicar/plan/researcher/review), 23.09.2026.*

## 9. DOKAZANO end-to-end (Vast, 23.09.2026.)
- `python gama_hc_harness.py --self-test` → **self_test=True**, 8 koraka (run xterm → activate → type → Return → OCR verifikacija), **6.2s**, screenshot dokaz. Implementacija: `.agents/skills/gama-hc-harness/gama_hc_harness.py`.
- **HC daemon format je JEDAN STRING**: `{"cmd":"tap 100 200"}`, `{"cmd":"type tekst"}`, `{"cmd":"run xterm"}`, `{"cmd":"key Return"}`; `{"cmd":"tap","x":..}` → "nepoznata komanda".
- **Koordinatni sistem**: `size` (Xvfb logički, npr. 1920x1080) ≠ framebuffer iz `shot_fast` (npr. 1280x720) → klik računaj na **framebuffer**.
- **OCR siječe zadnji znak** (`GAMA HC TES`) → `find()` normalizuje (samo a-z0-9) i poredi prvih 4 znaka.
- **DAG integracija**: `gama_dag.py --real` hc-čvor zove harness (`hc-harness`, `self_test=True`, dokaz screenshot).


## 🧾 OCR + NOVI ALATI (24.09.2026.)

- **OCR radnik:** Vast `:8045` (supervisor `gama-ocr`, jezici **bos+hrv+eng**), rezerva Oracle `:8045` (eng). Klijent `gama_ocr.py` (env `GAMACODE_OCR_URL`).
- **Alati (worker + chat):** `find_text{text,region}` (OCR → koordinate za klik; fallback lokalni OCR → UIA), `ocr_text{region}` (sav tekst sa ekrana).
- **Brzina:** region 700×250 ≈ 1.6 s; full screen ≈ 9.5 s; lokalni RapidOCR 11–14 s (ne koristi se u petlji).
- **Autonomni goal mode dokaz (ag9, OCR u petlji):** cilj „otvori Task Manager, nađi tekst preko `find_text`, klikni, zatvori" → 4. pokušaj **6 koraka → CILJ ZAVRSEN**, `goal.txt` automatski očišćen (3 prva pokušaja udarila `--steps 8` → za složene ciljeve digni `--steps` na 15–25).
- **Pokretanje goal radnika (pouzdano, bez lomljenja argumenata):** napiši `.cmd` fajl sa punim navodnicima i pokreni `Start-Process cmd -ArgumentList '/c','<putanja.cmd>' -WindowStyle Hidden` (NE `Start-Process python -ArgumentList @(...)` — lomi argumente sa razmakom).
