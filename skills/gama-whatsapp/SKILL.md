---
name: gama-whatsapp
description: Use for WhatsApp bot operations, sending voice messages, or interacting with WhatsApp for GAMA TRADE. Trigger: "whatsapp", "pošalji poruku", "glasovna poruka", "voice", "whatsapp bot".
---

# GAMA TRADE — WhatsApp Bot

## Arhitektura
- **Bot**: Baileys (bot-baileys.js)
- **Sumeja ("Sumi")**: Brzi chat, klasifikacija
- **Task Runner**: Izvršavanje zadataka u pozadini
- **Watchdog**: Nadzor i restart

## Lokacija
```
C:\Users\User\AppData\Local\Temp\opencode\whatsapp-bot\
```

## Glavni Fajlovi
| Fajl | Namjena |
|------|---------|
| bot-baileys.js | Glavni bot (Baileys) |
| task_runner.js | Izvršavanje zadataka |
| agent.js | AI agent logika |
| watchdog.js | Nadzor procesa |

## Glasovne Poruke (TTS)
```bash
# Edge TTS (besplatno, 300+ glasova)
edge-tts --voice bs-BA-GoranNeural --text "Hvala na narudžbi" --write-media hvala.mp3

# Konverzija u OGG Opus za WhatsApp
ffmpeg -i hvala.mp3 -c:a libopus -b:a 32k -ar 48000 -ac 1 -f ogg hvala.ogg
```

## dostupni glasovi
- **bs-BA-GoranNeural** — muški bosanski
- **bs-BA-VesnaNeural** — ženski bosanski
- **hr-HR-GabrijelaNeural** — hrvatski

## Pravila
- TTS slanje = OGG Opus 48kHz mono
- Transliteracija prije TTS (cyrToLat)
- STT: WSL audio_tools.py stt --language bs
- Status nadzor: active_task.json
