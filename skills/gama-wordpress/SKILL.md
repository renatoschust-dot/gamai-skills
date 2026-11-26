---
name: gama-wordpress
description: Use for WordPress/gamatrade.ba operations - page editing, product updates, REST API calls. Trigger: "wordpress", "gamatrade.ba", "stranica", "proizvod", "REST API".
---

# GAMA TRADE — WordPress (gamatrade.ba)

## Pristup
- **Admin**: Renato / GamTra123!"#
- **REST API User**: Renato
- **App Password**: VczK QO4P V4br 0cMA eZ7N 4ZFb
- **Base URL**: https://gamatrade.ba

## REST API Autentifikacija
```python
import requests
auth = ('Renato', 'VczK QO4P V4br 0cMA eZ7N 4ZFb')
r = requests.get('https://gamatrade.ba/wp-json/wp/v2/pages', auth=auth)
```

## Dostupni Endpointi
| Endpoint | Opis |
|----------|------|
| /wp-json/wp/v2/pages | Stranice |
| /wp-json/wp/v2/posts | Postovi |
| /wp-json/wp/v2/media | Slike |
| /wp-json/wc/v3/products | WooCommerce proizvodi |
| /wp-json/aioseo/v1/options | AIOSEO podešavanja |

## Struktura Sajta
- **Tema**: Avada (Ayada)
- **SEO**: AIOSEO plugin
- **Sitemap**: /sitemap_index.xml
- **Kategorije**: /kategorija-proizvoda/{brand}/
- **Proizvodi**: /proizvod/{slug}/

## AEO (AI Optimization)
- **llms.txt**: /llms.txt (200, kompletna mapa proizvoda)
- **FAQ**: U HTML opisu proizvoda (h2>Cesta pitanja, h3>Q, p>A)
- **sameAs**: FB, IG, YouTube, TikTok, LinkedIn u AIOSEO

## Pravila
- NE diraj AIOSEO options (kontrolira robots.txt)
- FAQ samo u HTML opisu (NE u JSON-LD)
- REST katkad vraća 500 za pages → koristi sitemap+HTML
- Slike: /wp-content/uploads/YYYY/MM/
