---
name: ocr-data-entry
description: Turn images, scans and PDFs into clean structured data - extract tables, invoices, receipts or forms into CSV/JSON/Excel. Use when the user uploads a photo or PDF of a document and wants the numbers out of it.
---

# OCR & Data Entry

Image/PDF in → clean structured data out. Never ship garbage silently.

## Pipeline

1. **Preprocess** — deskew, increase contrast, crop to the table/page. Low-quality scans fail without this.
2. **OCR** — recognize text *and* keep coordinates (needed to reconstruct rows and columns).
3. **Structure** — rebuild rows/columns from coordinates; one line item per row.
4. **Validate** — sanity rules: column sums match totals, dates parse, amounts are numeric, currency consistent.
5. **Output** — CSV (default), JSON, or XLSX.

## Output contract

- Header row exactly as on the document.
- Amounts numeric with a `.` decimal, currency in a separate column.
- Any cell that could not be read is left **empty** and listed in a `_unclear` column — never guessed.
- At the end print: rows extracted, rows with unclear cells, total check (sum vs printed total).

## Rules

- If the total on the document ≠ sum of recognized lines, **flag it** and stop for review.
- Never fabricate a missing digit.
- Keep the original order of rows.
- For multi-page documents, keep page number in a column.
- Report confidence: list any row that was reconstructed from weak OCR.
