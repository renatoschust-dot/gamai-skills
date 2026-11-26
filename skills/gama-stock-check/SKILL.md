---
name: gama-stock-check
description: Use when checking stock availability, quantities, or prices in GAMA TRADE databases. Handles SQL queries for artikli, zalihe, cijene. Trigger: "ima li na stanju", "koliko košta", "provjeri zalihe", "stock", "cijena artikla".
---

# GAMA TRADE — Provjera Zaliha/Stocka

## Baze Podataka
| Baza | Opis | Server |
|------|------|--------|
| vp2026 | VelikoProdaja 2026 | <node-ip> |
| mp2026 | MaloProdaja 2026 | <node-ip> |
| vp2025 | VelikoProdaja 2025 | <node-ip> |
| mp2025 | MaloProdaja 2025 | <node-ip> |

## SQL Konekcija
```python
import pyodbc
conn = pyodbc.connect(
    'DRIVER={SQL Server};SERVER=<node-ip>,1433;DATABASE=vp2026;UID=sa;PWD=SKUpro123'
)
```

## Osnovni Upiti

### Pronalaženje artikla
```sql
SELECT sifmat, nazivmat, cijena FROM mat 
WHERE nazivmat LIKE '%TRAŽENI POJAM%' OR sifmat LIKE '%ŠIFRA%'
```

### Provjera zaliha
```sql
SELECT sifmat, nazivmat, kolmat FROM sklad 
WHERE sifmat = 'ŠIFRA_ARTIKLA'
```

### Cijena artikla
```sql
SELECT sifmat, nazivmat, cijena, vpc FROM mat 
WHERE sifmat = 'ŠIFRA_ARTIKLA'
```

### Kupac (kupdob)
```sql
SELECT konto, naziv, ADRESA, mjesto, porbroj, matbroj 
FROM kupdob WHERE naziv LIKE '%NAZIV KUPCA%'
```

## Brza Pretraga (Python skripta)
```bash
python C:\Users\User\AppData\Local\Temp\opencode\sql_kupac_search.py "NAZIV"
```

## Pravila
- UVIJEK koristi COLLATE Latin1_General_CI_AI za LIKE (dijakritika)
- Tabela je `kupdob` (NE `kupci`)
- Kolone: sifmat, nazivmat (NE sifra, naziv)
- LTRIM(RTRIM(sifmat)) jer baza ima vodeće razmake
