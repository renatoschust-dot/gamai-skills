---
name: gama-computer-vision
description: COMPUTER VISION — Understand images, documents, receipts, products. See and interpret the visual world. OCR, image analysis, document parsing.
---

# GAMA COMPUTER VISION — Vještački Vid

## Šta Radi
Razumije SLIKE, DOKUMENTE, DOKUMENTE.

## Capabilities

### 1. Document OCR
```python
# Čitanje dokumenata iz slika
def ocr_dokument(slika):
    # Tesseract za osnovni OCR
    text = tesseract(slika, lang='eng+bos')
    
    # Napredni OCR za faktura
    faktura = extract_invoice(slika)
    return {
        "broj_fakture": faktura.broj,
        "datum": faktura.datum,
        "iznos": faktura.iznos,
        "dobavljac": faktura.dobavljac,
        "stavke": faktura.stavke
    }
```

### 2. Product Recognition
```python
# Prepoznavanje proizvoda iz slika
def prepoznaj_proizvod(slika):
    # Upari sa našim katalogom
    matches = match_with_catalog(slika, catalog_db)
    # Vrati najbolji match
    return best_match(matches)
```

### 3. Receipt Scanning
```python
# Skeniranje računa
def skeniraj_racun(slika):
    # Izvuci stavke
    stavke = extract_items(slika)
    # Izvuci ukupno
    ukupno = extract_total(slika)
    # Izvuci PDV
    pdv = extract_vat(slika)
    return {"stavke": stavke, "ukupno": ukupno, "pdv": pdv}
```

### 4. Business Card Scanner
```python
# Skeniranje vizit kartica
def skeniraj_vizit Kartu(slika):
    # Izvuci podatke
    ime = extract_name(slika)
    kompanija = extract_company(slika)
    telefon = extract_phone(slika)
    email = extract_email(slika)
    # Dodaj u bazu kupaca
    add_to_customers(ime, kompanija, telefon, email)
    return extracted_data
```

## Primjena u GAMA TRADE

### Supplier Invoices
```
Fotografiraj fakturu → OCR → Automatski unos u VP2026
```

### Product Catalog
```
Fotografiraj proizvod → Prepoznavanje → Pronađi u bazi → Cijena
```

### Customer Onboarding
```
Fotografiraj vizit kartu → OCR → Dodaj kupca u bazu
```

### PostIS Labels
```
Fotografiraj adresu → OCR → Automatska naljepnica
```

## Alati
| Alat | Upotreba |
|------|----------|
| Tesseract OCR | Osnovni OCR |
| EasyOCR | Napredni OCR |
| OpenCV | Obrada slika |
| YOLO | Detekcija objekata |
| CLIP | Razumijevanje slika |

## Integration
```
Slika → Vision API → Interpretacija → Akcija
  ↓
Kamera telefona → WhatsApp → Bot → Obrada
  ↓
Screenshot → Analiza → Izvještaj
```

## Voice + Vision Combo
```
"Hey GAMA, šta je ovo?"
  → Slika → Vision analiza → Glasovni odgovor
  → "Ovo je faktura od [dobavljača] u iznosu od [iznos]"
```
