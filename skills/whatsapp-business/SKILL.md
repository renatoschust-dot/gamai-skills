---
name: whatsapp-business
description: Handle WhatsApp Business conversations - answer customers, qualify leads, send catalog/prices, draft replies and follow-ups. Use when the user wants WhatsApp reply templates, a customer-service flow, or a bot script.
---

# WhatsApp Business

Keep replies short, human, and useful. WhatsApp is a chat, not email.

## Reply rules

- **Max 2-3 short lines** per message. Long paragraphs get ignored or mocked.
- Answer the actual question in the **first** line. No "Dear customer".
- One question per message, at the end.
- Voice notes only when the user asked or the topic is emotional/long.
- Never send more than 2 messages in a row without a reply.

## Conversation flow

1. **Greeting + intent** — acknowledge what they want in one line.
2. **Qualify** (max 2 questions): what exactly, quantity/deadline, location.
3. **Answer** with price/availability or a clear next step.
4. **Close** — "Da li da rezervišem?" / "Want me to send the invoice?"
5. **Follow-up** — allowed once after 24h, once after 72h, then stop.

## Templates to produce

- First reply to a new lead
- Price/availability answer
- "Out of stock, here's the alternative"
- Payment/IBAN reminder
- Delivery update
- Polite no / redirect

Each template: `When | Message (ready to copy) | Variables`. Keep placeholders in `{{...}}`.

## Rules

- Never invent prices, stock, or delivery dates — use `{{cijena}}` placeholders.
- Match the customer's language and formality.
- No emoji spam: max 1 per message.
- Never promise a discount you were not authorized to give.
