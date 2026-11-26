---
name: gama-email
description: Use when sending emails via SMTP for GAMA TRADE. Handles email composition, attachment sending, and email templates. Trigger: "posalji email", "email kupcu", "pošalji ponudu na mail", "email dokument".
---

# GAMA TRADE — Email (SMTP)

## SMTP Konfiguracija
- **Server**: gamatrade.ba
- **Port**: 26
- **Enkripcija**: STARTTLS
- **Autentifikacija**: AUTH LOGIN
- **User**: sumeja@gamatrade.ba
- **Password**: G4m45um3ja1
- **FROM**: sumeja@gamatrade.ba

## Python Kod (spreman za korištenje)
```python
import smtplib
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText
from email.mime.base import MIMEBase
from email import encoders

def posalji_email(primaoc, subjekt, sadrzaj, prilozi=None):
    msg = MIMEMultipart()
    msg['From'] = 'sumeja@gamatrade.ba'
    msg['To'] = primaoc
    msg['Subject'] = subjekt
    msg.attach(MIMEText(sadrzaj, 'html', 'utf-8'))
    
    if prilozi:
        for putanja in prilozi:
            with open(putanja, 'rb') as f:
                part = MIMEBase('application', 'octet-stream')
                part.set_payload(f.read())
                encoders.encode_base64(part)
                part.add_header('Content-Disposition', f'attachment; filename={putanja.split("/")[-1]}')
                msg.attach(part)
    
    with smtplib.SMTP('gamatrade.ba', 26) as server:
        server.starttls()
        server.login('sumeja@gamatrade.ba', 'G4m45um3ja1')
        server.send_message(msg)
    return True
```

## Primjeri Korištenja
- `posalji_email("kupac@example.com", "Ponuda br. 371", "<h1>Poštovani</h1>...", ["ponuda-371.pdf"])`
- Email za ponudu: HTML iz generisi-ponudu.ps1 + PDF prilog

## Pravila
- UVIJEK koristi HTML format za email
- Prilozi: PDF ponude, specifikacije
- Subject: "Ponuda br. [BROJ] - GAMA TRADE"
- Potpis: "GAMA TRADE d.o.o. | gamatrade.ba | +387 XX XXX XXX"
