---
name: gama-android-vm
description: "Android virtuelna mašina na zahtjev — Redroid Android 13, ADB, Scrcpy, testiranje APK-ova. Aktivira se na 'android vm', 'testiraj apk', 'android emulator', 'pokreni android', 'adb'."
---

# gama-android-vm — Android VM na Zahtjev

Android 13 u Docker kontejneru na GPU mašini — pravi Android bez fizičkog telefona.

## Šta nudimo

| Usluga | Šta dobiješ | Cijena |
|--------|------------|--------|
| Android VM sesija | Pravi Android 13, 30-60 min | $0.43/h |
| APK testiranje | Instaliraj + pokreni bilo koji APK | $0.43/h |
| ADB pristup | Pun terminal pristup Androidu | $0.43/h |
| Screen mirror | Vidi ekran u realnom vremenu | $0.43/h |

## Kako radi

### 1. Upali Android VM
```bash
# Na Thunder A6000 (GPU)
D:\ai\android_vm_up.sh
```
Skripta radi:
1. Upali Thunder A6000 instancu
2. Instalira Docker + Redroid Android 13
3. Pokreće Android kontejner
4. Vraća ADB + VNC pristup

### 2. Spoji se na Android
```bash
# ADB (terminal pristup)
adb connect <thunder_ip>:5555

# Scrcpy (screen mirror)
scrcpy -s <thunder_ip>:5555

# VNC (browser pristup)
# → http://<thunder_ip>:5900
```

### 3. Instaliraj APK
```bash
# Upload i instalacija
adb install moja_aplikacija.apk

# Pokreni
adb shell am start -n com.package/.MainActivity
```

### 4. Koristi Android
- Otvori apps
- Testiraj funkcionalnosti
- Screenshot / snimaj ekran
- Automatiziraj klikove (ADB commands)

### 5. Isključi
- Kad završiš → `D:\ai\thunder_backup.ps1 down`
- Plaćaš samo šta si koristio

## Infrastruktura

| Komponenta | Lokacija | Status |
|------------|----------|--------|
| Redroid Docker | Thunder A6000 backup | ✅ spreman |
| ADB | Android debug bridge | ✅ radi |
| Scrcpy | Screen mirroring | ✅ radi |
| VNC | Browser pristup | ✅ radi |
| Thunder A6000 | GPU backup snapshot | ✅ spreman |

## Primjeri korištenja

### Testiranje Android app-a
```bash
# 1. Upali VM
D:\ai\android_vm_up.sh

# 2. Upload APK
adb install -r /path/to/app.apk

# 3. Pokreni i testiraj
adb shell am start -n com.app/.Main

# 4. Screenshot za dokumentaciju
adb shell screencap /sdcard/screen.png
adb pull /sdcard/screen.png .

# 5. Isključi
D:\ai\thunder_backup.ps1 down
```

### Bot / automatizacija
```bash
# Klik na koordinatu
adb shell input tap 500 800

# Unos teksta
adb shell input text "hello"

# Scroll
adb shell input swipe 500 1000 500 300
```

## Cjenovnik

| Paket | Trajanje | Cijena |
|-------|----------|--------|
| Quick test | 30 min | $0.22 |
| Standard | 1 sat | $0.43 |
| Full day | 8 sati | $3.00 |

## Napomene
- Android 13 (Redroid) — pravi Android, ne emulator
- GPU ubrzava rendering (A6000 48GB)
- ADB + Scrcpy + VNC — puni pristup
- Instaliraj bilo koji APK
- Podaci ostaju na VM (ne gube se nakon isključenja ako se snapshot napravi)

## Verifikacija
- `adb devices` prikazuje `<ip>:5555   device`.
- `adb shell getprop ro.build.version.release` vraća `13`.
- `adb install -r app.apk` vraća `Success`; `adb shell pm list packages | grep <pkg>`.
- Screen mirror radi (`scrcpy`), screenshot sačuvan.
## Ograničenja
- Thunder instancu ugasi kad završiš (`thunder_backup.ps1 down`).
- Ne instaliraj nepoznate APK-ove bez skeniranja.
