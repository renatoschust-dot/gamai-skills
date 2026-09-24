---
name: "telegram-field-bot"
description: "Build Telegram bots for construction field workers. Real-time reporting, photo uploads, task assignments, progress tracking. Integrate with n8n for automated workflows."
homepage: "https://datadrivenconstruction.io"
metadata: {"openclaw": {"emoji": "📱", "os": ["darwin", "linux", "win32"], "homepage": "https://datadrivenconstruction.io", "requires": {"bins": ["python3"]}}}
---
# Telegram Field Bot

## Overview

Field workers need simple tools. Telegram bots provide instant communication, photo sharing, and task management without training or app downloads.

> "Telegram for field ops: Real-time task assignment and status updates" — DDC Community

## Why Telegram?

| Feature | Benefit |
|---------|---------|
| No training | Workers already use Telegram |
| Works offline | Messages sync when connected |
| Photos/videos | Easy visual documentation |
| Groups | Team coordination |
| Bots | Automated workflows |
| Free | No per-user licensing |

## Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                    TELEGRAM FIELD BOT                            │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  Field Worker              Bot                    n8n            │
│  ────────────              ───                    ───            │
│                                                                  │
│  📱 Send photo    ───▶    🤖 Receive     ───▶   ⚙️ Process     │
│  📝 Text report           📋 Parse              📊 Store        │
│  📍 Location              🏷️ Classify           📧 Notify       │
│                           ✅ Confirm            📈 Dashboard     │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

## Quick Start with n8n

### 1. Create Telegram Bot

```
1. Open Telegram, search @BotFather
2. Send /newbot
3. Name: "SiteReport Bot"
4. Username: "sitereport_company_bot"
5. Copy the API token
```

### 2. n8n Workflow

```json
{
  "workflow": "Telegram Field Reporting",
  "nodes": [
    {
      "name": "Telegram Trigger",
      "type": "Telegram",
      "event": "message",
      "token": "YOUR_BOT_TOKEN"
    },
    {
      "name": "Parse Message",
      "type": "Code",
      "code": "Parse message type: text, photo, location"
    },
    {
      "name": "Route by Type",
      "type": "Switch",
      "rules": ["photo", "text", "location", "command"]
    },
    {
      "name": "Process Photo",
      "type": "OpenAI Vision",
      "prompt": "Describe this construction site photo. Identify: progress, issues, safety concerns."
    },
    {
      "name": "Save to Database",
      "type": "PostgreSQL",
      "operation": "insert"
    },
    {
      "name": "Confirm to User",
      "type": "Telegram",
      "action": "sendMessage",
      "text": "✅ Report received! ID: {{report_id}}"
    }
  ]
}
```

## Bot Commands

```python
# /start - Welcome and instructions
# /report - Start daily report
# /photo - Upload site photo
# /issue - Report issue
# /progress - Update progress
# /weather - Log weather conditions
# /safety - Safety observation
# /help - Show commands
```

## Python Bot Implementation

```python
from telegram import Update, ReplyKeyboardMarkup
from telegram.ext import Application, CommandHandler, MessageHandler, filters, ContextTypes
import asyncio

# Bot token from BotFather
TOKEN = "YOUR_BOT_TOKEN"

# Keyboards
main_keyboard = ReplyKeyboardMarkup([
    ["📸 Photo Report", "📝 Text Report"],
    ["⚠️ Issue", "✅ Progress"],
    ["🌤️ Weather", "🦺 Safety"]
], resize_keyboard=True)

async def start(update: Update, context: ContextTypes.DEFAULT_TYPE):
    """Welcome message"""
    await update.message.reply_text(
        "👷 Site Report Bot\n\n"
        "Use the buttons below to submit reports.\n"
        "All reports are automatically logged and processed.",
        reply_markup=main_keyboard
    )

async def handle_photo(update: Update, context: ContextTypes.DEFAULT_TYPE):
    """Process photo submissions"""
    photo = update.message.photo[-1]  # Highest resolution
    file = await photo.get_file()

    # Download photo
    photo_path = f"photos/{update.message.chat.id}_{photo.file_id}.jpg"
    await file.download_to_drive(photo_path)

    # Get caption (description)
    caption = update.message.caption or "No description"

    # Get location if available
    location = None
    if update.message.location:
        location = {
            "lat": update.message.location.latitude,
            "lon": update.message.location.longitude
        }

    # Save to database (via n8n webhook or direct)
    report = {
        "type": "photo",
        "user_id": update.message.from_user.id,
        "username": update.message.from_user.username,
        "photo_path": photo_path,
        "caption": caption,
        "location": location,
        "timestamp": update.message.date.isoformat()
    }

    # Send to n8n for processing
    # requests.post("https://n8n.company.com/webhook/photo-report", json=report)

    await update.message.reply_text(
        f"✅ Photo received!\n"
        f"📝 Description: {caption}\n"
        f"🕐 Time: {update.message.date.strftime('%H:%M')}\n\n"
        "Photo will be analyzed and added to daily report."
    )

async def handle_text(update: Update, context: ContextTypes.DEFAULT_TYPE):
    """Process text reports"""
    text = update.message.text

    # Route based on button pressed
    if text == "📸 Photo Report":
        await update.message.reply_text("📸 Send a photo of the site with a description.")
    elif text == "📝 Text Report":
        await update.message.reply_text("📝 Type your progress report:")
    elif text == "⚠️ Issue":
        await update.message.reply_text(
            "⚠️ Describe the issue:\n"
            "- What is the problem?\n"
            "- Where is it located?\n"
            "- How urgent? (High/Medium/Low)"
        )
    elif text == "✅ Progress":
        await update.message.reply_text(
            "✅ Update progress:\n"
            "- What work was completed?\n"
            "- Percentage complete?\n"
            "- Any blockers?"
        )
    elif text == "🌤️ Weather":
        await update.message.reply_text(
            "🌤️ Weather conditions:\n"
            "- Temperature?\n"
            "- Conditions? (Clear/Rain/Snow/Wind)\n"
            "- Impact on work?"
        )
    elif text == "🦺 Safety":
        await update.message.reply_text(
            "🦺 Safety observation:\n"
            "- What did you observe?\n"
            "- Location?\n"
            "- Action taken?"
        )
    else:
        # Regular text report
        report = {
            "type": "text",
            "user_id": update.message.from_user.id,
            "username": update.message.from_user.username,
            "text": text,
            "timestamp": update.message.date.isoformat()
        }

        await update.message.reply_text("✅ Report logged!")

def main():
    """Start the bot"""
    app = Application.builder().token(TOKEN).build()

    app.add_handler(CommandHandler("start", start))
    app.add_handler(MessageHandler(filters.PHOTO, handle_photo))
    app.add_handler(MessageHandler(filters.TEXT & ~filters.COMMAND, handle_text))

    print("Bot started...")
    app.run_polling()

if __name__ == "__main__":
    main()
```

## Daily Report Aggregation

```python
def generate_daily_report(project_id: str, date: str) -> str:
    """Aggregate all Telegram reports into daily summary"""

    # Fetch all reports for the day
    reports = db.query("""
        SELECT * FROM telegram_reports
        WHERE project_id = ? AND DATE(timestamp) = ?
        ORDER BY timestamp
    """, [project_id, date])

    # Group by type
    photos = [r for r in reports if r['type'] == 'photo']
    issues = [r for r in reports if r['type'] == 'issue']
    progress = [r for r in reports if r['type'] == 'progress']

    # Generate summary with LLM
    summary = llm.summarize(f"""
        Daily reports for {date}:

        Photos submitted: {len(photos)}
        Issues reported: {len(issues)}
        Progress updates: {len(progress)}

        Details:
        {json.dumps(reports, indent=2)}

        Generate a concise daily report summary.
    """)

    return summary
```

## Group Chat Features

```python
# Track messages in project groups
async def handle_group_message(update: Update, context: ContextTypes.DEFAULT_TYPE):
    """Log important messages from project groups"""

    # Only log messages with keywords
    keywords = ["delay", "issue", "problem", "complete", "delivered", "inspection"]

    text = update.message.text.lower()
    if any(kw in text for kw in keywords):
        log_message({
            "group_id": update.message.chat.id,
            "group_name": update.message.chat.title,
            "user": update.message.from_user.username,
            "text": update.message.text,
            "timestamp": update.message.date.isoformat()
        })
```

## Requirements

```bash
pip install python-telegram-bot requests
```

## Resources

- python-telegram-bot: https://python-telegram-bot.org
- n8n Telegram: https://docs.n8n.io/integrations/builtin/app-nodes/n8n-nodes-base.telegram/
- BotFather: https://t.me/BotFather
