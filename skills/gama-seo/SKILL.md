---
name: gama-seo
description: Use for SEO optimization of gamatrade.ba - meta tags, schema markup, content optimization, AEO. Trigger: "SEO", "meta", "schema", "optimiziraj stranicu", "AEO", "AI pronalezivost".
---

# GAMA TRADE — SEO + AEO (gamatrade.ba)

## Pristup
- **REST Auth**: Renato / `VczK QO4P V4br 0cMA eZ7N 4ZFb` (Basic)
- **Base**: https://gamatrade.ba
- **AIOSEO**: v4.9.5.1 (NE v5) — roboti kontrolišu preko fizičkog robots.txt

## WordPress REST Endpointi
```
GET  /wp-json/wp/v2/products          → lista proizvoda
POST /wp-json/wp/v2/product/{id}      → izmjena (content = opis + JSON-LD)
GET  /wp-json/wc/v3/products          → WooCommerce (opis, cijena, stock)
POST /wp-json/wc/v3/products/{id}     → izmjena WooCommerce podataka
GET  /wp-json/aioseo/v1/options       → AIOSEO podešavanja
```

## AEO (AI Engine Optimization) — KLJUČNO
Cilj: pojaviti se u ChatGPT/Gemini/Perplexity odgovorima.

### 1. Product JSON-LD
```python
import requests
auth = ('Renato', 'VczK QO4P V4br 0cMA eZ7N 4ZFb')
schema = '''<script type="application/ld+json">
{"@context":"https://schema.org","@type":"Product",
"name":"...","description":"...","brand":{"@type":"Brand","name":"GAMA TRADE"},
"aggregateRating":{...},"offers":{"@type":"Offer","price":"...","priceCurrency":"BAM"}}
</script>'''
r = requests.post('https://gamatrade.ba/wp-json/wp/v2/product/{id}',
                  auth=auth, json={'content': opis + schema})
```
- Čita se preko `wc/v3` (wp/v2 content.raw je prazan)
- Čuva se preko `wp/v2` (wc/v3 struže `<script>`)

### 2. FAQ vidljiv u opisu
```html
<h2>Cesta pitanja</h2>
<h3>Koliko košta?</h3><p>...</p>
<h3>Je li na stanju?</h3><p>...</p>
```
- Vidljivi HTML u `description` — AI čitaju vidljivi tekst
- RADI preko WC REST (opisa čuva se u description)

### 3. sameAs (AIOSEO social)
FB, IG, YouTube, TikTok, LinkedIn u AIOSEO social podešavanjima.

## llms.txt
- `https://gamatrade.ba/llms.txt` = 200, radi
- NE dirati (generiše se automatski)

## robots.txt
- Fizički fajl na serveru, AIOSEO ne kontroliše
- AI botovi DOZVOLJENI: `User-agent: *` — nema AI blokova

## On-Page SEO Checklist
- [ ] Title: ≥30 i ≤60 znakova, sa ključnom riječju
- [ ] Meta description: 120-160 znakova
- [ ] H1: tačno 1, sadrži ključnu riječ
- [ ] H2-H3: hijerarhija, FAQ
- [ ] Slike: ALT tekst + naziv fajla
- [ ] Interni linkovi: ≥2 prema drugim proizvodima
- [ ] JSON-LD: Product shema
- [ ] Brzina: slike komprimirane

## Skripte
- `gama_aeo_schema_wpv2.py` (--apply [N] / --revert, backup u D:\ai\backup\)
- `gama_aeo_faq_final.py` (vidljivi FAQ)
- `gama_aeo_full.py`
- Urađeno: Product JSON-LD na 330 proizvoda, FAQ na 10+ ključnih

## Pravila
- NE diraj AIOSEO options (kontroliše robots.txt fizički)
- FAQ samo u HTML opisu (vidljivo), NE u JSON-LD
- pages REST katkad 500 → koristi sitemap + HTML