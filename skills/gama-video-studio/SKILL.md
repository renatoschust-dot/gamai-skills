---
name: gama-video-studio
description: "AI video za socijalne mreže — Reels, TikTok, Shorts, kompresija, montaža, konverzija. Radi na GPU. Aktivira se na 'video za instagram', 'reels', 'tiktok klip', 'ai video', 'komprimiraj video'."
---

# gama-video-studio — AI Video Studio

Video montaža i obrada za socijalne mreže — na GPU, brzo, jeftino.

## Šta nudimo

| Usluga | Šta dobiješ | Cijena |
|--------|------------|--------|
| Kompresija videa | Manja datoteka, isti kvalitet | Besplatno |
| Konverzija formata | MP4→WebM, MOV→MP4, bilo šta | Besplatno |
| Reels/TikTok format | 9:16, 60s, optimiziran za mobile | Besplatno |
| Thumbs+cover | Screenshot + naslovnica | Besplatno |
| Video AI opis | Opis + hashtagovi za post | Besplatno |

## Kako radi

### 1. Kompresija / konverzija
```bash
# FFmpeg — radi na Oracle (besplatno) ili Vast (GPU)
ffmpeg -i input.mp4 -c:v libx264 -crf 23 -preset medium output.mp4
```

### 2. Reels/TikTok format
```bash
# 9:16 vertikalni format, 60s max
ffmpeg -i input.mp4 -vf "crop=ih*9/16:ih" -t 60 -c:v libx264 reels.mp4
```

### 3. Thumbs generation
```bash
# Prvi kadar kao naslovnica
ffmpeg -i input.mp4 -ss 00:00:01 -vframes 1 thumb.jpg
```

### 4. AI video opis
```python
# Model generiše opis + hashtagove za post
# Pozovi qwen3-coder:30b preko tunela
```

## Alati (stvarno rade)

| Alat | Lokacija | Status |
|------|----------|--------|
| FFmpeg | Oracle + Vast | ✅ radi |
| Playwright Chromium | Linux3 + Vast | ✅ radi |
| edge-tts (glasovni) | Windows + WSL | ✅ radi |
| PIL/Pillow | WSL | ✅ radi |

## Format outputa

### Instagram Reels / TikTok / YouTube Shorts
- **Format:** 1080×1920 (9:16)
- **Trajanje:** 15-60 sekundi
- **Codec:** H.264 MP4
- **Audio:** AAC 128kbps

### Instagram Feed
- **Format:** 1080×1080 (1:1)
- **Trajanje:** 60s max
- **Codec:** H.264 MP4

### YouTube
- **Format:** 1920×1080 (16:9)
- **Trajanje:** bez limita
- **Codec:** H.264 MP4

## Primjer korištenja

Korisnik: "Napravi Reels od ovog videa za Instagram"

Agent:
1. Upload video
2. FFmpeg crop → 9:16
3. Kompresija za mobile
4. Generiše thumbnail
5. AI opis + hashtagovi
6. Spremi na desktop

## Napomene
- Sve radi lokalno (ne uploadujemo na treće strane)
- GPU ubrzava rendering (Vast 3090)
- Besplatno za kompresiju/konverziju ( FFmpeg na Oracle)
