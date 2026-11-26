---
name: gama-racunovodstvo
description: Računovodstvo za GAMA TRADE — knjiženje faktura, kontni plan, bilans, zaključci. Aktivira se na 'računovodstvo', 'knjiženje', 'bilans', 'kontni plan', 'zaključak'.
---

# GAMA Računovodstvo — knjiženje i pregled

Vodič kroz računovodstvene operacije specifične za GAMA TRADE.

## OSNOVNI TOK
1. **Ulaz robe** → kalkulacija ulaza (`vkalk`) → knjiženje u KUF.
2. **Izlaz robe (prodaja)** → faktura (`kalk`) → knjiženje u KIF.
3. **Plaćanja** → izvodi banke → knjiženje na konto kupca/dobavljača.
4. **Kraj mjeseca** → obračun PDV-a, zaključak.

## KONTNI PLAN (osnovni za GAMA TRADE)
| Konto | Opis |
|---|---|
| 1300 | Kupci (potraživanja) |
| 1310 | Dobavljači (obaveze) |
| 2000 | Roba na zalihi (vrijednost) |
| 4010 | Prihod od prodaje |
| 5010 | Nabavna vrijednost prodate robe |
| 4400 | Ostali prihodi |
| 5200 | Troškovi materijala |
| 5300 | Troškovi zarada |
| 5400 | Troškovi usluga |
| 5500 | Amortizacija |

## VP2026 — knjiženje
- VP2026 automatski knjiži fakture u odgovarajuće konta.
- `kupdob` tabela: kupci (konto, naziv, adresa, JIB, PDV).
- Provjeri da su konta ispravno postavljena prije knjiženja.
- Mjesečni pregled prometa: `SELECT ... FROM kalk WHERE datum BETWEEN ...`

## IZVODI BANKE
- Uvoz izvoda (CSV/XML) → knjiženje uplata.
- Poveži uplatu sa fakturom (broj fakture u pozivu na broj).
- Otvorene stavke: provjeri koje fakture još nisu plaćene.

## BILANS STANJA I USPJEHA
- **Bilans stanja**: Aktiva = Pasiva (na kraju perioda).
  - Aktiva: stalna sredstva + obrtna sredstva (zalihe, kupci, keš).
  - Pasiva: kapital + obaveze (dobavljači, krediti).
- **Bilans uspjeha**: Prihodi − Rashodi = Dobit/Gubitak.
  - Prihodi: prodaja, ostali prihodi.
  - Rashodi: nabavna vrijednost, plate, materijal, usluge, amortizacija.

## GODIŠNJI ZAKLJUČAK
1. Popis imovine i obaveza (inventura).
2. Obračun amortizacije.
3. Rezervisanja (neplaćene obaveze).
4. Poreski obračun (porez na dobit 10%).
5. Finansijski izvještaji (bilans stanja, bilans uspjeha, izvještaj o tokovima gotovine).
6. Predaja APR-u (elektronski).

## GAMA SPECIFIČNOSTI
- **Uvoz** (ino dobavljači): carina + špedicija se knjiže kao zavisni troškovi nabavke.
- **Izvoz**: prihod bez PDV-a, knjiži se posebno.
- **Garancije/reklamacije**: povrat robe → storno fakture.
- **Otpis**: rashodovana/uništena roba se knjiži kao rashod.

## KOMANDE (za agenta)
- Pregled kupaca: `python D:\ai\sql_kupac_search.py "NAZIV"`
- Pregled prometa: SQL `SELECT ... FROM kalk WHERE ...`
- Fakture: VP2026 `kalk` + `kustavke`
