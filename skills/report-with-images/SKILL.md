---
name: report-with-images
description: Produce a finished report or document (DOCX + PDF) with real images in a single command - research the topic, find and download images, assemble the document. Use when the user says "make a report", "make a document about X", "with images", "export to PDF".
---

# Report with Images

One task in, a finished `.docx` + `.pdf` (with images and captions) out.

## Pipeline

1. **Content** — gather facts on the topic (search + read sources). Structure as: title, intro, 3-6 sections (each a heading + 2-4 short paragraphs).
2. **Images** — search image sources, collect candidate URLs, pick the best per section.
3. **Download** — fetch images through a browser context (this also bypasses naive hotlink/referer blocks). If a URL returns 403/404, skip it and take the next candidate — do not stop.
4. **Assemble** — build the document with a real image per section and a caption; export DOCX and then PDF.

## Output contract

- `<out>.docx` and `<out>.pdf` must both exist and be **> 5 KB**.
- Every image has a caption and a source note.
- Text reads in the user's language (BS/HR/SR/EN).

## Rules

- The output path is the filename **without extension**.
- An image may come from a URL or a local file path — support both.
- Never publish anything anywhere; the document stays local.
- Verify at the end: file exists, size > 5 KB, page count > 1.
- If no image can be downloaded, deliver the document with a placeholder box and say so — never a broken image.
