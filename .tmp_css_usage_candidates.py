import re
from pathlib import Path

candidates = [
    "doc-pill",
    "hero-badges",
    "hero-terminal",
    "hero-terminal-header",
    "landing-hero-bleed",
    "section-heading",
    "tabbed-set",
    "hero-content",
    "hero-actions",
]
files = []
for root in ["docs", "overrides"]:
    path = Path(root)
    if path.exists():
        files.extend(
            [
                p
                for p in path.rglob("*")
                if p.is_file() and p.suffix.lower() in {".md", ".html", ".yml", ".yaml"}
            ]
        )
if Path("mkdocs.yml").exists():
    files.append(Path("mkdocs.yml"))
if Path("config").exists():
    files.extend(
        [
            p
            for p in Path("config").rglob("*")
            if p.is_file() and p.suffix.lower() in {".yml", ".yaml"}
        ]
    )
print("Scanning", len(files), "source files")
for cand in candidates:
    found = []
    pattern_attrs = re.compile(r'class\s*=\s*["\"][^"\
]*\b' + re.escape(cand) + r"\b")
    for p in files:
        text = p.read_text(encoding="utf-8", errors="ignore")
        if (
            pattern_attrs.search(text)
            or re.search(r"\{:\s*\." + re.escape(cand) + r"\b", text)
            or (
                p.suffix.lower() == ".md"
                and re.search(r"\b" + re.escape(cand) + r"\b", text)
            )
        ):
            found.append(str(p))
    print(cand, "->", len(found))
    for f in found[:20]:
        print("  ", f)
