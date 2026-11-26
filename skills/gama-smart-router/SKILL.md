---
name: gama-smart-router
description: MASTER SKILL — Automatically selects the right skill and approach for any GAMA TRADE task. Use at the start of any task to determine the best workflow. Always use this first.
---

# GAMA TRADE — Smart Router (Majstor Skill)

## Pravilo: UVIJEK prvo koristi ovaj skill!
Ovaj skill bira KOJI drugi skill koristiti za zadatak.

## Routing Mapa

### Ponude i Dokumenti
| Zadatak | Skill | Brzina |
|---------|-------|--------|
| Nova ponuda | `gama-ponuda-workflow` | 3-5 min |
| Izmjena ponude | `gama-ponuda-workflow` | 2-3 min |
| Email ponude | `gama-email` | 1 min |
| PDF generisanje | `gama-ponuda-workflow` | 3-5 min |

### Baze Podataka
| Zadatak | Skill | Brzina |
|---------|-------|--------|
| Pretraga kupaca | `gama-customer-search` | 5s |
| Provjera zaliha | `gama-stock-check` | 5s |
| SQL upit | `gama-stock-check` | 5-10s |
| Kalkulacija ulaza | `kalkulacije-vp2026` | 10-15 min |
| Upis u VP2026 | `vp2026-workflow` | 5-10 min |

### Komunikacija
| Zadatak | Skill | Brzina |
|---------|-------|--------|
| Email slanje | `gama-email` | 1 min |
| WhatsApp poruka | `gama-whatsapp` |即时 |
| Glasovna poruka | `gama-whatsapp` | 2-3 min |
| PostIS naljepnica | `agent-rdp` | 5-10 min |

### Web i Marketing
| Zadatak | Skill | Brzina |
|---------|-------|--------|
| WordPress izmjena | `gama-wordpress` | 5-10 min |
| SEO analiza | `gama-wordpress` | 15-30 min |
| Google Ads | ručno | 30+ min |

### Infrastruktura
| Zadatak | Skill | Brzina |
|---------|-------|--------|
| RDP/KASA | `agent-rdp` | 5-15 min |
| Server pristup | SSH direktno | 1-5 min |
| Oracle AI | semapi endpoint |即时 |

## Query Klasifikacija

### automation keywords:
- "ponuda", "ponudu", "cijena" → `gama-ponuda-workflow`
- "račun", "faktura", "ulaz" → `vp2026-workflow` ili `kalkulacije-vp2026`
- "kupac", "partner", "adresa" → `gama-customer-search`
- "stanje", "zalihe", "koliko" → `gama-stock-check`
- "email", "pošalji" → `gama-email`
- "whatsapp", "poruka" → `gama-whatsapp`
- "stranica", "sajt" → `gama-wordpress`
- "RDP", "KASA", "fiskalni" → `agent-rdp`

## Headroom Integracija
- Svi SQL rezultati → headroom komprimira JSON
- Svi HTML outputi → headroom komprimira
- Veliki tool outputi → headroom komprimira

## Primjer
Korisnik: "Napravi ponudu za ALFA HADŽIĆI, 5 komada artikla 1234"

1. **Smart Router** → `gama-ponuda-workflow`
2. **Customer Search** → `gama-customer-search` (nađi ALFA HADŽIĆI)
3. **Stock Check** → `gama-stock-check` (provjeri artikal 1234)
4. **Ponuda Workflow** → kreiraj ponudu
5. **Email** → pošalji na mail kupca
6. **Headroom** → komprimira sve outpute
