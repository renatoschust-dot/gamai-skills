---
name: gama-voice-first
description: VOICE-FIRST INTERFACE — Talk to the system, voice commands, voice responses, hands-free operation. The future of interaction.
---

# GAMA VOICE-FIRST — Glasovno Sučelje

## Šta Radi
Cijeli sistem se može kontrolirati GLASOM.

## Voice Pipeline

### 1. STT (Speech-to-Text)
```bash
# Whisper Large V3 (najbolji)
python D:\ai\audio_tools.py stt audio.mp3 --language bs

# ili edge-tts za TTS
edge-tts --voice bs-BA-GoranNeural --text "Tekst" --write-media output.mp3
```

### 2. Intent Recognition
```
"Pošalji ponudu ALFA HADŽIĆI"
  → Intent: SEND_OFFER
  → Entity: customer=ALFA HADŽIĆI
  → Action: gama-ponuda-workflow
```

### 3. Voice Response
```python
def generisi_odgovor(tekst):
    # Konvertuj tekst u govor
    voice = edge_tts(tekst, voice="bs-BA-GoranNeural")
    # Pošalji kao glasovnu poruku
    send_voice_message(voice)
```

## Voice Commands za GAMA

### Ponude
- "Napravi ponudu za [kupac]"
- "Pošalji ponudu broj [broj]"
- "Koliko košta [artikl]?"

### Baza podataka
- "Koliko ima [artikl] na stanju?"
- "Ko je kupac [naziv]?"
- "Prikaži fakture za [mjesec]"

### Email
- "Pošalji email [kupcu] sa ponudom"
- "Pročitaj zadnje emailove"
- "Odgovori na email od [pošiljaoca]"

### WhatsApp
- "Pošalji poruku [kupcu]"
- "Šta je rekao [kupac]?"
- "Glasovna poruka [kupcu]"

### Finansije
- "Koliko smo zaradili [mjesec]?"
- "Koji je profit?"
- "Koliko duguje [kupac]?"

## Implementation

### Korak 1: Voice Capture
```
Windows Whisper → audio → tekst
```

### Korak 2: Intent Parsing
```
Tekst → LLM klasifikacija → Intent + Entities
```

### Korak 3: Action
```
Intent → Skill selection → Execution
```

### Korak 4: Voice Response
```
Odgovor → Edge TTS → Audio → Pošalji
```

## Hands-Free Mode
```
Aktivacija: "Hey GAMA"
  → Čeka komandu
  → Izvršava
  → Priča rezultat
  → Čeka sljedeću komandu
```

## Multi-Language
- **Bosanski** (primarni) - bs-BA-GoranNeural
- **Engleski** - en-US-GuyNeural
- **Njemački** - de-DE-ConradNeural

## Advanced Features

### Voice Cloning
```
Kloniraj glas vlasnika firme
→ Personaliziran AI asistent
```

### Emotion Detection
```
Prepoznaj emociju u glasu
→ Prilagodi odgovor
```

### Multi-Turn Conversation
```
Vođenje razgovora kroz nekoliko pitanja
→ Kompleksni zadaci glasom
```
