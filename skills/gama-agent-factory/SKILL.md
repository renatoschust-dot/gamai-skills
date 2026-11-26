---
name: gama-agent-factory
description: "Izrada privatnih AI agenata za firme. Custom agent koji radi zadatke 24/7. Aktivira se na 'napravi agenta', 'ai agent za firmu', 'privatni agent', 'automatizuj biznis'."
---

# gama-agent-factory — Fabrika AI Agenata

Custom AI agent za firmu — radi 24/7, privatno, bez mjesečnih troškova za cloud.

## Šta je "privatni agent"

AI asistent koji:
- Radi na NAŠIM računarima (Vast GPU / Oracle)
- Čuva podatke privatno (ne izlaze iz mreže)
- Obavlja konkretne zadatke (mail, SQL, ponude, dokumenti)
- Ne treba ChatGPT pretplatu ($20/mj)

## Paketi

| Paket | Šta dobiješ | Cijena |
|-------|------------|--------|
| Starter | Agent za chat + pretragu (qwen3-coder:30b) | €49/mj |
| Business | Agent + alati (mail, SQL, dokumenti) | €99/mj |
| Enterprise | Custom agent + trening na tvojim podacima | €199/mj |

## Kako kreiramo agenta

### 1. Razumijemo potrebe firme
- Šta agent treba raditi? (mail, SQL, ponude, chat...)
- Koji podaci? (šifrarnik, kupci, cijene...)
- Koja pristupa? (email, baza, sajt...)

### 2. Kreiramo agenta
```bash
# Primjer: agent za GAMA TRADE
# - Čita kupce iz SQL (kupdob tabela)
# - Generiše ponude (brza_ponuda.py)
# - Šalje mailove (SMTP gamatrade.ba)
# - Pretražuje šifrarnik (semapi)
```

Agent se gradi od:
- **Modela:** qwen3-coder:30b (Vast GPU, privatno)
- **Skillova:** specijalizovani SKILL.md fajlovi
- **Alata:** SQL, mail, web, OCR, semantička pretraga
- **Konfiguracije:** agent.js / providers.js

### 3. Deploy na GPU
```bash
# Mala Vast 24/7 — agent radi non-stop
# Ollama endpoint: 127.0.0.1:11434
# Model: qwen3-coder:30b (ili po potrebi)
```

### 4. Korisnik koristi
- WhatsApp chat sa agentom
- Ili API poziv iz vlastite aplikacije
- Agent radi zadatke automatski

## Primjeri agenata (stvarno radi)

| Agent | Šta radi | Infra |
|-------|----------|-------|
| GAMA Chat | Chat, pretraga šifrarnika, ponude | Vast 3090 24/7 |
| GAMA Pošta | Email + WhatsApp odgovori | Oracle semapi |
| GAMA SQL | Upiti nad bazom kupaca/artikala | Oracle + SQL Server |
| GAMA Vision | OCR fakture, čitanje slika | Vast qwen2.5vl:7b |

## Tehnička infrastruktura

- **GPU:** Vast RTX 3090 (24/7) — privatna inferencija
- **Modeli:** qwen3-coder:30b, deepseek-r1:32b, gemma4:26b, qwen2.5vl:7b
- **Baza:** SQL Server (kupci, artikli, cijene)
- **Pretraga:** semapi (3405 stavki, semantička pretraga)
- **Komunikacija:** WhatsApp Baileys, SMTP email
- **Operator:** OpenCode agentic CLI

## Napomene
- Agent NE napušta našu mrežu (privatnost)
- Nema OpenAI/Anthropic API poziva (jeftinije)
- Custom po potrebi firme
