---
name: gama-accounting
description: Use for accounting tasks - invoices, receipts, VAT, ledgers, financial reports. Trigger: "račun", "faktura", "predračun", "otpremnica", "PDV", "bilans", "knjiženje".
---

# GAMA TRADE — Računovodstvo (Fiskalni + Knjiženje)

## SQL Pristup
- Server: `<node-ip>`, user `sa`, pass `SKUpro123`, baza `vp2026`

## Tabele
| Tabela | Opis |
|--------|------|
| kalk/kustavke | Fakture (zaglavlje + stavke) |
| kuusluge | Usluge po fakturi |
| pfkalk | Razduženje robe (po VPC) |
| vkalk/vstavke | Kalkulacija ulaza robe |
| mat | Artikli (sifmat, nazivmat, cijena, vpc) |
| kupdob | Kupci (konto, naziv, adresa, JIB) |

## Fiskalni Račun (Tring)
- JEDNA stavka: `Promet po fakturi:{brkalk}`
- Ide preko VP2026 workflow-a (agent-rdp / RDP)

## PDV Obračun (17%)
```sql
-- PDV na fakturu
SELECT brkalk, SUM(bpdv) AS osnovica, SUM(ipdv) AS pdv, SUM(iznos) AS ukupno
FROM kustavke WHERE brkalk = @broj GROUP BY brkalk

-- Obračun:
-- Osnovica × 0.17 = PDV
-- Osnovica + PDV = Ukupno
```

## Knjiženje (FK)
1. Kreiraj FK zaglavlje (kupac, datum, osnovica)
2. Dodaj stavke (artikl, količina, cijena, PDV)
3. Knjiži u FK tabelu
4. Korekcije → PFKALK (razduženje po VPC)

## Izvještaji
```sql
-- Dnevni promet
SELECT CONVERT(date, datum) dan, SUM(iznos) promet
FROM kalk GROUP BY CONVERT(date, datum)

-- Mjesečni promet po kupcima
SELECT k.konto, k.naziv, SUM(f.iznos) promet
FROM kalk f JOIN kupdob k ON f.konto = k.konto
WHERE YEAR(f.datum) = YEAR(GETDATE())
GROUP BY k.konto, k.naziv ORDER BY promet DESC

-- Neplaćene fakture (30+ dana)
SELECT * FROM kalk WHERE naplaceno = 0 AND datum < DATEADD(day,-30,GETDATE())
```

## Pravila
- PDV 17% uvijek u zasebnim kolonama
- Bosanski jezik ijekavica
- Fiskalni račun → JEDNA stavka "Promet po fakturi:{brkalk}"
- Razduženje robe po VPC (NE VPC+PDV)