---
name: gama-inventory
description: Upravljanje zalihama za GAMA TRADE — stanje, ulaz robe, izlaz robe, reklamacije, inventura, SQL upiti za zalihe. Aktivira se na 'zalihe', 'stock', 'stanje', 'ima li na stanju', 'inventura', 'ulaz robe'.
---

# GAMA Inventory — upravljanje zalihama

Vodič za praćenje i upravljanje zalihama u VP2026 sistemu.

## PROVJERA STANJA (SQL)
Osnovni SQL upit za stanje artikla:
```sql
SELECT mat.sifmat, mat.nazivmat, stanje.kolicina, stanje.ulaz, stanje.izlaz
FROM mat LEFT JOIN stanje ON mat.sifmat = stanje.sifmat
WHERE mat.sifmat = LTRIM(RTRIM('SIFRA'))
```
Baze: `vp2026` (tekuća), `vp2025`, `mp2026`, `mp2025`, `mp2024`.

## BRZA PROVJERA (agent komanda)
```
python D:\ai\sql_kupac_search.py "SIFRA"  -- traži artikal
```
Ili kroz SQL agent: "koliko je SIFRA na stanju?"

## ULAGANJE ROBE (nabavka)
1. **Kalkulacija ulaza** (`vkalk` + `vstavke` tabele):
   - Unesi dobavljača, broj fakture, datum.
   - Za svaku stavku: šifra artikla, količina, nabavna cijena.
   - PDV (17% ili bez za ino), zavisni troškovi (prevoz, carina).
2. Nakon unosa VP2026 automatski ažurira `stanje` tabelu (povećava količinu).
3. Verifikuj: uporedi fizički primljeno sa unesenim.

## IZLAZ ROBE (prodaja)
1. **Faktura** (`kalk` + `kustavke` tabele):
   - Unos prodajne fakture automatski smanjuje stanje.
2. Provjeri: da li je dovoljno na stanju prije fakture?
3. Ako je negativno → VP2026 upozorava (ne dopušta negativno stanje).

## REKLAMACIJE I POVRAT
1. **Povrat od kupca**: knjiži se kao storno faktura ili knjižno zaduženje.
2. **Povrat dobavljaču**: knjiži se kao storno kalkulacije ulaza.
3. Stanje se automatski koriguje.

## INVENTURA (godišnje/polu-godišnje)
1. Fizički popis svih artikala na skladištu.
2. Uporedi sa stanjem u VP2026 (`stanje` tabela).
3. **Manjak**: knjiži se kao rashod (piše se u `pfkalk`).
4. **Višak**: knjiži se kao prihod (korekcija stanja).
5. Inventurni elaborat (dokument sa popisnim listama).

## PRAĆENJE MINIMALNIH ZALIHA
- Za svaki artikal koji se često prodaje, postavi `min_zaliha`.
- Kad padne ispod minimuma → automatska narudžba dobavljaču (ili alert).

## KOMANDE (za agenta)
- SQL: `SELECT ... FROM stanje WHERE kolicina < 5` — svi artikli ispod kritične zalihe.
- Sistem: `COMPLETE_UNIFIED_DATABASE.json` ima 2660 artikala sa cijenama (ažuriran sedmično).

## NAPOMENA
Stanje u VP2026 je KNJIGOVODSTVENO — uvijek provjeri fizičko stanje kod sumnje. Razlike mogu nastati zbog grešaka u unosu, krađe, oštećenja.
