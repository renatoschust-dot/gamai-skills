#!/usr/bin/env python3
"""Count where the skills in this library say they came from.

Every skill is a `skills/<name>/SKILL.md`. Its frontmatter may carry `source:` — a URL,
an upstream project, or `community` — which is the only attribution this repository has.
Skills without it are not attributed anywhere, and that is what this report makes visible.

    python3 tools/provenance_report.py           # summary + top sources
    python3 tools/provenance_report.py --list    # every unattributed skill name
"""
from __future__ import annotations

import argparse
import collections
import pathlib
import re
import sys

ROOT = pathlib.Path(__file__).resolve().parents[1]
SKILLS = ROOT / "skills"
SOURCE = re.compile(r"^\s*source:\s*(.+?)\s*$", re.M)


def scan() -> tuple[dict[str, int], list[str]]:
    sources: collections.Counter[str] = collections.Counter()
    unattributed: list[str] = []
    for path in sorted(SKILLS.glob("*/SKILL.md")):
        head = path.read_text(encoding="utf-8", errors="ignore")[:2000]
        match = SOURCE.search(head)
        if match:
            sources[match.group(1).strip().strip("\"'")] += 1
        else:
            unattributed.append(path.parent.name)
    return sources, unattributed


def main(argv: list[str]) -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--list", action="store_true", help="print unattributed skill names")
    args = ap.parse_args(argv[1:])
    sources, unattributed = scan()
    total = sum(sources.values()) + len(unattributed)
    print(f"skills: {total}   attributed: {sum(sources.values())}   unattributed: {len(unattributed)}")
    if sources:
        print("\ntop sources:")
        for name, count in sources.most_common(15):
            print(f"  {count:4d}  {name[:90]}")
    if args.list:
        print("\nunattributed:")
        for name in unattributed:
            print(f"  {name}")
    return 0


if __name__ == "__main__":
    sys.exit(main(sys.argv))
