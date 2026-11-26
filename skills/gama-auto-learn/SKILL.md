---
name: gama-auto-learn
description: Automatically learns new skills when encountering unknown tasks. Searches internet, reads docs, creates reusable skills. The self-improving engine.
---

# GAMA AUTO-LEARN — Samoučeći Sistem

## Pravilo: Kad ne znaš KAKO → nauči!

## Protocol

### 1. Detekcija Nepoznatog
```
Zadatak nije pokriven skill-om?
  → AKTIVIRAJ auto-learn
```

### 2. Istraživanje
```python
# Korak 1: Pretraži dokumentaciju
websearch("[tehnologija] documentation tutorial 2026")

# Korak 2: Provjeri Context7 za live docs
context7_resolve-library-id("[biblioteka]")
context7_query-docs(libraryId, "kako se koristi")

# Korak 3: GitHub search za primjere
websearch("site:github.com [problem] implementation")
```

### 3. Učenje
```
1. Pročitaj dokumentaciju
2. Razumij koncept
3. Napiši pseudokod
4. Implementiraj
5. Testiraj
6. Doradi
```

### 4. Kreiranje Skilla
```
Kad naučiš nešto novo:
1. Napravi SKILL.md
2. Dodaj YAML frontmatter
3. Uključi primjere koda
4. Spremi u skills folder
5. Update-aj registry
```

### 5. Memory Store
```
Sve što naučiš → claude-mem observation
Tako drugi agenti mogu koristiti tvoje znanje
```

## Primjeri Auto-Learn

### Primjer 1: "Napravi mobilnu aplikaciju"
```
1. Pretraži: "React Native tutorial 2026"
2. Context7: react-native docs
3. Nauči: setup, navigation, components
4. Kreiraj: gama-mobile-app skill
5. Implementiraj app
6. Spremi skill za budućnost
```

### Primjer 2: "Automatiziraj računovodstvo"
```
1. Pretraži: "Python accounting software"
2. GitHub: "open source accounting python"
3. Nauči: double-entry bookkeeping
4. Kreiraj: gama-accounting-automation skill
5. Implementiraj
6. Spremi
```

## Alati za Učenje
| Alat | Namjena |
|------|---------|
| websearch | Pretraga interneta |
| context7 | Live dokumentacija biblioteka |
| graphify | Razumijevanje koda |
| claude-mem | Pamćenje naučenog |
| headroom | Kompresija za jeftinije učenje |

## Pravila
- UVIJEK provjeri postoji li skill prije učenja
- Spremi sve što naučiš
- Dijeli znanje sa drugim agentima
- Budi efikasan - ne uči ono što već znaš
