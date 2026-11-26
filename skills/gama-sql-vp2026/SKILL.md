---
name: gama-sql-vp2026
description: "GAMA TRADE SQL radnik — verifikovani upiti nad vp2026/mp2026 bazama. Koristi za SVAKI upit o: šifri i cijeni artikla, stanju/zalihi, zadnjem ulazu robe, prodaji po kupcu, prometu (mjesec/godina), top kupcima/artiklima, nosačima/diznama/pumpama, kupcima i kontima, PDV/kontiranju, ulazu robe. Trigger: 'šifra', 'cijena', 'koliko košta', 'ima li na stanju', 'zaliha', 'lager', 'kad je ušao', 'zadnji ulaz', 'kome se prodavalo', 'promet', 'top kupci', 'koliko kupaca', 'kontiranje', 'ulaz robe', 'vp2026', 'SQL', 'baza'. Ne koristi za pisanje u bazu (upis fakture → skill vp2026-workflow)."
---

# GAMA — SQL radnik za VP2026

Tvoj posao: dati **tačan** broj/cijenu/stanje iz GAMA baze, bez nagađanja. Uvijek koristi `gama_sql` (MCP) ili gateway `POST :8070/v1/sql`. Read-only.

## 0. Prvo pročitaj reference
- **`references/GAMA-SQL-COOKBOOK.md`** — 30 testiranih recepata (copy-paste, zamijeni `...`).
- **`references/GAMA-VP2026-SCHEMA.md`** — data dictionary ključnih tabela + poznati problemi.
- **`references/GAMA-TRADE-KB.md`** — asortiman/mašine, ključna konta (kupci/dobavljači), Comprag cijene, gdje je koja dokumentacija (GAMA_TRADE_ZNANJE.md).

## 1. Pravila (bez ovoga daješ pogrešan broj)
1. `char` kolone su padded → **uvijek `RTRIM()`** (`sifmat`, `nazivmat`, `brkalk`, `konto`).
2. Nazivi često imaju `\r\n` → `REPLACE(RTRIM(naziv),CHAR(13),'')`.
3. `kalk.napomena` / `mat.moeancod` su `text` → `CAST(... AS nvarchar(255))` prije funkcija.
4. **`mat.vpc` = cijena BEZ PDV**, **`mat.mpc` = cijena SA PDV** (×1.17). `zal.vpc` je NEPOUZDAN → cijena iz `mat`.
5. Glavno skladište `sifskl='001'`.
6. **Prodaja = `kalk`+`kustavke`; Ulaz = `vkalk`+`vstavke`; Usluge = `kuusluge`.** Ne miješati.
7. Kupci/dobavljači su u **`kupdob`** (tabela `KUPCI` je prazna). Kupac konto `211xxx`.
8. **Nema saldo tabele** → dugovanja approx preko `kalk.plac=0`.

## 2. Brzi recepti (puni SQL u cookbooku)

**Šifra + cijena po nazivu (R1/R4):**
```sql
SELECT RTRIM(sifmat) sifra, REPLACE(RTRIM(nazivmat),CHAR(13),'') naziv, RTRIM(jm) jm,
       vpc AS bez_pdv, CAST(vpc*1.17 AS numeric(18,2)) sa_pdv, mpc
FROM mat WHERE nazivmat LIKE '%nosa%' AND nazivmat LIKE '%G40%' ORDER BY nazivmat;
```

**Stanje / ima li na lageru (R6/R7):**
```sql
SELECT RTRIM(m.sifmat) sifra, RTRIM(m.nazivmat) naziv, m.vpc, m.mpc,
       ISNULL(SUM(z.kol),0) stanje
FROM mat m LEFT JOIN zal z ON RTRIM(z.sifmat)=RTRIM(m.sifmat)
WHERE m.sifmat LIKE '15F442%' GROUP BY m.sifmat,m.nazivmat,m.vpc,m.mpc;
```

**Zadnji ulaz robe za artikal (R11):**
```sql
SELECT TOP 20 k.datum, RTRIM(k.brfakture) faktura, v.kol, v.fakcij, RTRIM(d.naziv) dobavljac
FROM vkalk k JOIN vstavke v ON v.brkalk=k.brkalk
LEFT JOIN dobav d ON RTRIM(d.konto)=RTRIM(k.konto)
WHERE RTRIM(v.sifmat)='249256' ORDER BY k.datum DESC;
```

**Kome se prodavao artikal (R14):**
```sql
SELECT TOP 20 k.datfakt, s.kol, REPLACE(RTRIM(kd.naziv),CHAR(13),'') kupac, RTRIM(k.brkalk) faktura
FROM kalk k JOIN kustavke s ON s.brkalk=k.brkalk
LEFT JOIN kupdob kd ON RTRIM(kd.konto)=RTRIM(k.konto)
WHERE RTRIM(s.sifmat)='24D439' ORDER BY k.datfakt DESC;
```

**Promet period (R17):**
```sql
SELECT CAST(SUM(s.kol*s.fakcij) AS numeric(18,2)) neto,
       CAST(SUM(s.kol*s.fakcij)*1.17 AS numeric(18,2)) bruto, COUNT(DISTINCT k.brkalk) faktura
FROM kalk k JOIN kustavke s ON s.brkalk=k.brkalk WHERE k.datfakt >= '2026-01-01';
```

**Top kupci (R18) / Top artikli (R19) / Vrijednost lagera (R8):** vidi cookbook.

**Nađi kupca (R22):**
```sql
SELECT RTRIM(konto) konto, REPLACE(RTRIM(naziv),CHAR(13),'') naziv, RTRIM(mjesto) mjesto
FROM kupdob WHERE naziv LIKE '%MASTERWOOD%';
```

## 3. Protokol odgovora
1. Ako upit nije 100% jasan (koja baza? koji period? koji kupac?) → pitaj kratko.
2. Uvijek prikaži: **šifru, naziv, cijenu (bez/sa PDV), stanje** i **izvor** (tabela/upit).
3. Ako nema rezultata → reci "nema u bazi" + ponudi varijantu pretrage (dio naziva/dio šifre).
4. Kod više pogodaka (npr. "nosač") → izlistaj sve sa šifrom+cijenom+stanjem, pusti korisnika da izabere.
5. Nikad ne izmišljaj cijenu/stanje. Ako SQL ne vrati → "ne mogu potvrditi".

## 4. Primjeri iz prakse (06.10.2026)
- "nosač dizne G40" → `15F442 Drzac dizne G40` (165/193,05, stanje 0); `24D439 Nosač zračne kape G40` (165/193,05, stanje 2); `249256 Nosač zračne kape` (152/177,84, VP 0 / MP 2).
- "PerformAA nosač" → `26B801 Nosač zračne kape (PerformAA 50)` (200/234, stanje 2).
- "zadnje stiglo, prodato MASTERWOOD-u, imam 2" → `aam211 Dizna AAM 211 air mix`: ulaz 05.10.2026 (5 kom), prodato Masterwoodu (konto 211286) 05.10.2026 (3 kom), stanje 2.

## 5. Veza sa ostalim
- **Upis** (faktura, ulaz, ponuda) → skill `vp2026-workflow`.
- **Kontiranje/PDV** → skill `gama-kasa`, memorija `gama/pdv.md`.
- **Ponude** → skill `gama-ponuda`.
