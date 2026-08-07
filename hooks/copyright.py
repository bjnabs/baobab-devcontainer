"""
hooks/copyright.py

Resolves a `{year}` placeholder inside mkdocs.yml's `copyright` string with
the current UTC year at build time, so the footer never carries a stale
year and never needs a manual annual edit.

This is plain MkDocs core "hooks" functionality (config.hooks, supported
since MkDocs 1.4) — a plugin-style Python module referenced directly from
mkdocs.yml's top-level `hooks:` list, requiring no additional package.

zensical.toml must contain the literal placeholder, e.g.:

    copyright: >-
      Copyright &copy; {year} Nabhold.
      Licensed under the Apache License 2.0.

If the placeholder is absent, `str.format()` is a no-op and this hook has
no effect — safe to leave registered even if the copyright string is ever
rewritten without the placeholder.
"""

from __future__ import annotations

from datetime import datetime, timezone
from typing import Any


def on_config(config: dict[str, Any], **kwargs: Any) -> dict[str, Any]:

    current_year = datetime.now(timezone.utc).year

    copyright_text = config.get("copyright")

    if copyright_text:
        config["copyright"] = copyright_text.format(year=current_year)

    return config