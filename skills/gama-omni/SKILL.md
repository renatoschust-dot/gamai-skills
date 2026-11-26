---
name: gama-omni
description: MASTER ORCHESTRATOR — Handles ANY task automatically. Routes to best skills, learns new ones if needed, self-organizes. Use this for EVERYTHING. The brain of the system.
---

# GAMA OMNI — Univerzalni Orchestrator

## Pravilo: OVO JE POČETNA TAČKA ZA SVE

Kad god korisnik kaže bilo šta, prvo pokreni OVU.

## Kako Radi

### 1. Analiza zadatka
```
Zadatak → Klasifikacija → Routing
  ├── Poznat zadatak → postojeći skill
  ├── Nepoznat zadatak → auto-learn
  └── Kompleksan zadatak → paralelni agenti
```

### 2. Skill Selection Matrix
| Kategorija | Skill | Prioritet |
|------------|-------|-----------|
| Ponuda/Dokument | gama-ponuda-workflow | HIGH |
| Baza podataka | gama-stock-check | HIGH |
| Email | gama-email | MEDIUM |
| WhatsApp | gama-whatsapp | MEDIUM |
| WordPress/SEO | gama-seo | MEDIUM |
| Računovodstvo | gama-accounting | HIGH |
| Inventar | gama-inventory | HIGH |
| RDP/KASA | agent-rdp | HIGH |
| Marketing | gama-marketing | LOW |
| Finansije | gama-finance | LOW |

### 3. Auto-Learn Protocol
Kad skill NE POSTOJI za zadatak:
```python
1. Analiziraj šta treba uraditi
2. Pretraži internet za rješenje
3. Nauči kako se radi
4. Kreiraj novi skill
5. Testiraj ga
6. Spremi za budućnost
```

### 4. Paralelni Agenti
Za velike zadatke → dispatch više agenata:
```
Agent 1: Istraživanje
Agent 2: Implementacija  
Agent 3: Testiranje
Agent 4: Dokumentacija
→ Svi rade istovremeno
```

### 5. Headroom Integracija
- SVI tool outputi → headroom komprimira
- Manje tokena = jeftinije = brže

### 6. Memory Integration
- claude-mem: pamti SVE što radimo
- knowledge search: pretraži znanje prije akcije
- graf: veze između koncepata

## Primjer Korištenja

Korisnik: "Napravi mi web shop za prodaju alata"

1. **Omni** → klasifikira: "web development + e-commerce"
2. **Auto-learn** → traži: "WordPress WooCommerce setup"
3. **Dispatch** → 3 agenta paralelno:
   - Agent 1: WordPress instalacija
   - Agent 2: WooCommerce podešavanje
   - Agent 3: Import proizvoda iz GAMA baze
4. **Memory** → pamti šta smo naučili
5. **Revenue** → povezuje sa monetizacijom

## Komande
- "uradi [štagod]" → omni routing
- "nauči [što]" → auto-learn
- "zaradi [kako]" → revenue pipeline
- "pamti [šta]" → memory store
