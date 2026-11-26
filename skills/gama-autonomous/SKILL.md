---
name: gama-autonomous
description: AUTONOMOUS AGENTS — Agents that work without supervision, make decisions, handle complex workflows. Self-healing, self-optimizing.
---

# GAMA AUTONOMOUS — Samostalni Agenti

## Pravilo: Agenti rade SAMI, čovjek samo verificira

## Autonomy Levels

### Level 1: Assisted (Trenutno)
```
Čovjek kaže → Agent radi → Čovjek verificira
```

### Level 2: Supervised (Cilj)
```
Čovjek postavlja cilj → Agent radi sam → Čovjek pregleda
```

### Level 3: Autonomous (10x)
```
Čovjek kaže "zaradi" → Agent sam bira šta radi → Čovjek prima izvještaj
```

## Autonomous Workflows

### 1. Auto-Email Pipeline
```
Trigger: a new offer appears in the system
  → Agent čita podatke kupca
  → Generira personaliziran email
  → Šalje email
  → Logira u claude-mem
  → Čeka 3 dana
  → Ako nema odgovora → follow-up
  → Ako ima → obradi odgovor
```

### 2. Auto-Stock Management
```
Trigger: Zalihe ispod minimuma
  → Agent provjeri trend prodaje
  → Kalkulira optimalnu količinu
  → Generira narudžbu dobavljaču
  → Šalje email dobavljaču
  → Prati isporuku
  → Ažurira bazu kad stigne
```

### 3. Auto-Customer Follow-up
```
Trigger: 30 dana od zadnje kupovine
  → Agent provjeri kupca
  → Generira personaliziranu ponudu
  → Šalje email/WhatsApp
  → Prati odgovor
  → Ako nema → drugi kanal
  → Ako ima → obradi
```

### 4. Auto-Content Creation
```
Trigger: Nova nedjelja
  → Agent analizira šta je bilo popularno
  → Generira 7 postova za društvene mreže
  → Planira objave
  → Automatski objavljuje
  → Prati angažman
  → Optimizira buduće postove
```

## Decision Making

### Kriteriji za odluke
```python
def donesi_odluku(opcije):
    for opcija in opcije:
        opcija.score = (
            opcija.financial_impact * 0.4 +
            opcija.customer_satisfaction * 0.3 +
            opcija.time_savings * 0.2 +
            opcija.risk_level * 0.1
        )
    return max(opcije, key=lambda x: x.score)
```

### Escalation Rules
```
Automatski:
- Iznos < 100 KM → Agent odlučuje sam
- Iznos 100-1000 KM → Agent predlaže, čovjek verificira
- Iznos > 1000 KM → Čovjek odlučuje

Rizik:
- Nizak rizik → Agent sam
- Srednji rizik → Agent + notifikacija
- Visok rizik → Čovjek mora odobriti
```

## Self-Healing
```
Ako nešto padne:
  1. Agent detektira problem
  2. Pokušava popraviti (retry, restart)
  3. Ako ne uspije → eskalira čovjeku
  4. Logira šta se desilo
  5. Uči iz greške
```

## Monitoring
```
Svaki agent šalje heartbeat:
- Status: radi/ne radi
- Zadnja aktivnost: timestamp
- Zadaci: što radi
- Greške: ako ih ima

Dashboard: https://<node-ip>:9443
```

## Autonomy Score
```
0-25%: Čovjek radi sve
25-50%: Agent pomaže
50-75%: Agent radi, čovjek verificira
75-90%: Agent radi sam, čovjek pregleda
90-100%: Agent radi sve, čovjek samo postavlja ciljeve

Trenutno: ~40%
Cilj: ~85%
```
