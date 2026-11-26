---
name: gama-customer-search
description: Use when searching for customers/partners in GAMA TRADE database. Handles customer lookup, JIB/PDV search, address verification. Trigger: "traži kupca", "ko je kupac", "JIB", "PDV broj", "adresa kupca".
---

# GAMA TRADE — Pretraga Kupaca

## Baza: vp2026 → Tabela: kupdob

## SQL Upiti

### Po nazivu
```sql
SELECT konto, naziv, ADRESA, mjesto, postbroj, porbroj, matbroj, telefon, mobitel 
FROM kupdob 
WHERE naziv COLLATE Latin1_General_CI_AI LIKE '%NAZIV%'
```

### Po šifri (kontu)
```sql
SELECT * FROM kupdob WHERE konto = 'ŠIFRA'
```

### Po JIB/MAT broju
```sql
SELECT * FROM kupdob WHERE matbroj LIKE '%JIB%'
```

### Po mjestu
```sql
SELECT konto, naziv, ADRESA, mjesto FROM kupdob 
WHERE mjesto COLLATE Latin1_General_CI_AI LIKE '%MJESTO%'
```

## Brza Pretraga (Python)
```bash
python C:\Users\User\AppData\Local\Temp\opencode\sql_kupac_search.py "NAZIV_KUPCA"
```

## Pravila
- Tabela je **kupdob** (NE kupci - ta je prazna!)
- Kolone: konto, naziv, ADRESA, mjesto, postbroj, porbroj, matbroj
- Koristi COLLATE Latin1_General_CI_AI za dijakritiku
- Fallback: probaj prvu riječ naziva ako ne nađeš cijeli
- Za PostIS: UVIJEK izvuci podatke iz ADRESARA, nikad ručno
