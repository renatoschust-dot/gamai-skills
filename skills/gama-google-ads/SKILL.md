---
name: gama-google-ads
description: Google Ads oglašavanje za GAMA TRADE — kampanje, ključne riječi, budžet, mjerenje, API. Aktivira se na 'Google Ads', 'kampanja', 'ključne riječi', 'oglašavanje', 'budžet ads'.
---

# Google Ads — oglašavanje za GAMA TRADE

Vodič za Google oglase specifično za GAMA TRADE.

## NALOZI
- **Oglasivač CID**: `7058812084` (Gama Trade doo).
- **Manager MCC**: `4963669352` ("GAMA TRADE Manager") — API pristup ovdje.
- **API kredencijali**: u `C:\Users\User\Desktop\GAMA_ADS_API\.env` — developer_token, client_id, client_secret, refresh_token.

## STRUKTURA KAMPANJE
```
Kampanja → Ad Grupa → Oglasi + Ključne riječi
```
- **Kampanja**: budžet, ciljanje, strategija licitacije.
- **Ad Grupa**: tematska grupa (npr. "Airless farbanje", "Pjeskarenje").
- **Oglas**: naslovi, opisi, URL.
- **Ključne riječi**: šta ljudi traže.

## VRSTE KAMPANJA
- **Search (Pretraživačka)**: tekstualni oglasi u rezultatima pretrage. NAJBOLJA za GAMA (ljudi aktivno traže opremu). Koristi za specifične proizvode.
- **Performance Max**: Google automatski plasira na svim mrežama. Manje kontrole ali veći domet.
- **Display**: banner oglasi na sajtovima — za podsjećanje (remarketing).

## KLJUČNE RIJEČI (za GAMA proizvode)
| Tip | Primjeri |
|---|---|
| Proizvod | "masina za farbanje", "pjeskara", "graco airless" |
| Brend | "graco", "wagner", "contracor", "airblast" |
| Problem | "kako ofarbati zid", "skidanje stare boje" |
| Namjena | "oprema za gradiliste", "industrijsko farbanje" |

## NEGATIVNE KLJUČNE RIJEČI (obavezno!)
- olx, kupujem prodajem, polovno, balkanbiz, polovni, besplatno
- Ovo sprečava da se oglas prikazuje na nevažnim upitima → štedi budžet.

## BUDŽET I LICITACIJA
- Dnevni budžet: počni nisko (npr. 10-20 KM/dan) pa povećavaj na osnovu rezultata.
- Licitacija: "Maksimiziraj klikove" za početak, "Ciljani CPA" kad imaš podatke o konverzijama.
- Prosječna cijena klika (CPC) za B2B opremu na Balkanu: 0.50-2.00 KM.

## MJERENJE (konverzije)
- **Šta je konverzija**: poziv, forma, prodaja, upit.
- GA4 tag (`G-P9D6Y1SXQC`) je već na sajtu.
- Poveži Google Ads sa GA4 za uvid u ponašanje nakon klika.

## LANDING STRANICE (gamatrade.ba)
- `/kategorija-proizvoda/graco/` — Graco proizvodi
- `/kategorija-proizvoda/airblast/` — Airblast (pjeskarenje)
- `/proizvod/masina-za-pjeskarenje-pjeskara/`
- `/proizvod/graco-ultra-795-xt-...farbanje/`
- Svaka ključna riječ vodi na RELEVANTNU stranicu (ne na početnu!).

## API (za automatizaciju, kad token prođe production review)
```python
# C:\Users\User\Desktop\GAMA_ADS_API\.env
# create_search_campaign.py — kreiranje kampanje automatski
# gads_audit.py — pregled naloga, kampanja, ključnih riječi
```
Developer token trenutno na razini "Explorer" (test) — za production treba Google recenziju (dani).

## ČESTE GREŠKE
- Nema negativnih ključnih riječi → budžet se troši na nevažne upite.
- Sve ključne riječi vode na homepage → loš quality score.
- Nije podešeno geografsko ciljanje (BiH/Ex-YU).
- Kampanje se ne provjeravaju sedmicama → novac se slijeva.

## KOMANDE (za agenta)
- API audit: `python C:\Users\User\AppData\Local\Temp\opencode\gads_audit.py`
- Search kampanja plan: `C:\Users\User\Desktop\GAMA_R7_SEARCH_PLAN.md`
