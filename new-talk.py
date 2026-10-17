#!/usr/bin/env python3
"""Create an independent research talk from the template."""

import argparse
import json
from pathlib import Path
import re
import shutil
import sys


def main(argv=None):
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("directory", type=Path, help="a new directory to create")
    parser.add_argument("--title", default="Paper title: the central contribution")
    parser.add_argument("--subtitle", default="A short subtitle for the research talk")
    parser.add_argument("--authors", default="Author One, Author Two, Author Three")
    parser.add_argument("--affiliation", default="Research group / University")
    parser.add_argument("--system", default="Research System")
    args = parser.parse_args(argv)

    source = Path(__file__).resolve().parent
    destination = args.directory.resolve()
    if destination.exists():
        parser.error(f"destination already exists; no files changed: {destination}")

    replacements = {
        "[Paper title: the central contribution]": args.title,
        "[A short subtitle for the research talk]": args.subtitle,
        "[Author One, Author Two, Author Three]": args.authors,
        "[Research group / University]": args.affiliation,
        '"Research System"': args.system,
    }
    created = False
    try:
        text = (source / "starter.typ").read_text(encoding="utf-8")
        text = text.replace('"lib.typ"', '"template/lib.typ"')
        pattern = re.compile("|".join(re.escape(key) for key in replacements))
        text = pattern.sub(
            lambda match: json.dumps(replacements[match.group()], ensure_ascii=False), text
        )
        destination.mkdir(parents=True, exist_ok=False)
        created = True
        (destination / "template").mkdir()
        (destination / "assets").mkdir()
        shutil.copy2(source / "lib.typ", destination / "template" / "lib.typ")
        shutil.copy2(source / "LICENSE", destination / "template" / "LICENSE")
        for name in ("AGENT.md", "build.py", ".gitignore"):
            shutil.copy2(source / name, destination / name)
        (destination / "main.typ").write_text(text, encoding="utf-8")
    except OSError as error:
        if created:
            shutil.rmtree(destination)
        parser.error(str(error))

    print(f"Created {destination}\nNext: python3 {destination / 'build.py'}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
