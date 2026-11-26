---
name: gama-pdv
description: PDV u Bosni i Hercegovini — obračun 17%, prijava PDV-a, ulazni/izlazni PDV, evidencija, ePorezi, rokovi, registracija. Aktivira se na 'PDV', 'porez na dodanu vrijednost', 'PDV prijava', 'obračun PDV-a', 'faktura s PDV-om'.
---

# PDV — obračun, prijava i evidencija za GAMA TRADE

Vodič kroz PDV specifično za GAMA TRADE poslovanje (trgovina opremom, BiH).

## OSNOVE
- **Stopa: 17%** (standardna PDV stopa u BiH).
- GAMA TRADE je obveznik PDV-a (promet prelazi 100.000 KM godišnje).
- **Izlazni PDV**: 17% na prodajnu cijenu (bez PDV-a). Npr. cijena 1000 KM + 17% = 1170 KM (sa PDV-om).
- **Ulazni PDV**: 17% na nabavnu cijenu — ovaj se odbija od izlaznog.
- **Za uplatu u budžet** = izlazni PDV − ulazni PDV. Ako je pozitivno → plaćaš. Ako negativno → poreski kredit (prebijaš sljedeći mjesec).

## OBRAČUN (mjesečno)
1. Zbroj svih izlaznih faktura → izlazni PDV.
2. Zbroj svih ulaznih faktura (nabavka roba/usluga) → ulazni PDV.
3. Obračunaj razliku.
4. Ako je za uplatu >0, plati do 10. u mjesecu.

## PRIJAVA PDV-a (ePorezi)
- Prijava se podnosi **mjesečno** kroz portal ePorezi (FBiH / RS).
- **Rok**: do 10. u mjesecu za prethodni mjesec.
- Potrebno: PDV broj, certifikat za ePoreze, zbirni podaci o prometu.
- PDV obrazac (PDV-1) sadrži: ukupan promet, izlazni PDV, ulazni PDV, razlika.

## GAMA TRADE SPECIFIČNOSTI
- **VP2026 fakture**: prilikom unosa fakture u `kalk` tabelu, VP2026 automatski obračunava PDV. Provjeri da su stope ispravne (17% na robu).
- **Ino dobavljači (EU/ino)**: faktura bez PDV-a → obračunava se "reverse charge" (samoobračunavanje PDV-a). U VP2026: šifra PDV-a za ino.
- **Izvoz**: faktura bez PDV-a (0%). Evidentira se u PDV prijavi u posebnoj rubrici.
- **Maloprodaja (fiskalna)**: PDV je uračunat u cijenu. Mjesečno se iz fiskalnih izvještaja izvlači ukupan PDV.

## EVIDENCIJA (obavezno čuvati)
- Knjiga izlaznih faktura (KIF)
- Knjiga ulaznih faktura (KUF)
- Obračuni PDV-a (mjesečni)
- Sve fakture — 10 godina (elektronski ili papirno)

## ČESTE GREŠKE
- Zaboravljeni ulazni PDV (npr. režije, gorivo, materijal — i to ima PDV koji se odbija).
- Pogrešna stopa (npr. 17% umjesto 0% za izvoz).
- Kašnjenje prijave → kazna + kamata (0.04% dnevno).

## KOMANDE (za agenta)
- `python D:\ai\sql_kupac_search.py "NAZIV"` — provjera kupca (PDV broj u `kupdob`).
- VP2026 kalk faktura → automatski PDV obračun.
