---
name: gama-teleport
description: META-SKILL teleporta — "morph" skill za BRZO kreiranje novih GAMA skillova. Koristi D:\ai\gama_skill_gen.py (scan/search/make) + skill-expert kvalitet + gama-lang. Aktivira se na 'teleport skill', 'morph skill', 'napravi mi skill', 'brzi skill', 'kreiram skill', 'generisi novi skill', 'skill za X', 'treba mi skill za ...'. Cilj: iz prirodnog jezika u gotov SKILL.md za <30 sekundi, bez ručnog pisanja.
---

# GAMA TELEPORT — Brzi Skill Creator (morph/teleport)

Pretvara prirodno-jezički zahtjev u **gotov, funkcionalan SKILL.md** koristeći
postojeći generator (`gama_skill_gen.py`) kao jezgro. Ne piše se ručno — teleportuje.

## 1. JEZGRO (uvijek tako)

Generator: `python D:\ai\gama_skill_gen.py`
- `scan`          → pregled svih skillova + kategorije
- `search "t"`    → provjera postoji li već (VAŽNO: prvo provjeri!)
- `make <ime> <opis> [--cat kategorija]` → KREIRA SKILL.md iz imena+opisa

Koristi ga uvijek; nemoj pisati SKILL.md od nule ako generator može.

## 2. TOK (teleport, ~30 s)

1. **ROUTIRAJ** — razumi šta korisnik želi: novi skill, izmjena postojećeg,
   popis (=scan), ili provjera (=search).

2. **PROVJERI DUPLE** — `python D:\ai\gama_skill_gen.py search "<ključ>`"
   Ako postoji → preskoči kreiranje, reci korisniku ime postojećeg. Gotovo.

3. **KREIRAJ** (novi skill):
   ```
   python D:\ai\gama_skill_gen.py make <ime> "<opis>"
   ```
   - `<ime>`: kebab-case (npr. `gama-solar`, `servis-klima`)
   - `<opis>`: **1-2 rečenice**, šta skill radi + okidači ("Aktivira se na 'klima ne hladi'...")
   - opc. dodaj `--cat <domena>` (gama/kod/dizajn/marketing/... iz DOMENI u generatoru)

4. **NADOPUNA (skill-expert kvalitet)** — generator daje osnovni SKILL.md.
   Otvori `.agents/skills/<ime>/SKILL.md` i po potrebi dopuni po principima skill-expert:
   - **Progressive disclosure**: samo bitno u frontmatter, detalji u tijelu
   - **Konkretni okidači** u `description` (kada se skill aktivira)
   - **Provjera rezultata / validacija** u koracima (evidencija prije tvrdnje)
   - Bez praznih placeholder foldera, bez suvišnih README/CHANGELOG

5. **OPC. gama-lang** — ako je predmet programerski/automatizacijski i treba
   mini-program, može se ugraditi `.gama` skripta (vidi `gama-lang` skill).

6. **VERIFIKUJ** — skeniraj da je upao:
   ```
   python D:\ai\gama_skill_gen.py search "<ime>"
   ```
   Treba vratiti hit. Zatim pošalji korisniku ime + putanju + 1-linijski opis.

## 3. PRIMJERI

```
# Korisnik: "treba mi skill za čišćenje klima uređaja"
# 1. search
python D:\ai\gama_skill_gen.py search "klima"
# 2. (nema hit) →
python D:\ai\gama_skill_gen.py make gama-servis-klima "Servis i ciscenje klima uredjaja - filteri, gas, kvarovi, instalacija. Aktivira se na 'klima ne hladi', 'servis klima', 'gas klima'." --cat gama
# 3. dopuni SKILL.md po skill-expert principima
# 4. search "klima" → hit "gama-servis-klima" ✓
```

## 4. KTITERIJI "GOTOVO"

- Skill postoji u `.agents/skills/<ime>/SKILL.md` (verificirano `search`)
- Frontmatter ima `name` + `description` sa okidačima
- Nema ružnih placeholder foldera/fajlova
- `CHANGELOG` u `GAMA_TEAM_STATE.md` dobio red (dodaj ručno ili de <ime>)

## 5. Automatizacija (izborno, za masovnu proizvodnju)

Za generisanje VIŠE skillova odjednom ili iz liste niša koristi harvester:
```
python D:\ai\gama_skill_harvester.py gen "ime" "opis"
python D:\ai\gama_skill_harvester.py report   # gap analiza
```
Za dohvat postojećih javnih skillova sa GitHub-a (skillselion/vercel CLI):
```
npx -y skills add https://github.com/<repo> --skill <ime>
```
u `.agents/skills/<ime>`.
