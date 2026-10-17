#!/usr/bin/env python3
"""Compile a talk with Gill Sans MT and keep generated PDFs in build/."""

import argparse
import os
from pathlib import Path
import shutil
import subprocess
import sys
import time


def main(argv=None):
    here = Path(__file__).resolve().parent
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("source", nargs="?", type=Path)
    parser.add_argument("--root", type=Path, help="Typst project root")
    parser.add_argument("--output", type=Path, help="override build/<source>.pdf")
    parser.add_argument("--font-path", action="append", default=[], metavar="DIR")
    parser.add_argument("--watch", action="store_true", help="rebuild on changes")
    args = parser.parse_args(argv)

    default = here / ("main.typ" if (here / "main.typ").exists() else "starter.typ")
    source = (args.source or default).resolve()
    root = (args.root or source.parent).resolve()
    output = (args.output or root / "build" / source.with_suffix(".pdf").name).resolve()

    if not source.is_file():
        parser.error(f"source file does not exist: {source}")
    if not root.is_dir() or root not in source.parents:
        parser.error("--root must be a directory containing the source file")
    if source == output:
        parser.error("output must differ from the source file")
    if shutil.which("typst") is None:
        parser.error("Typst is missing. Install Typst >= 0.11.1 and try again.")

    paths = list(args.font_path)
    paths.extend(filter(None, os.environ.get("SLIDES_FONT_PATH", "").split(os.pathsep)))
    for candidate in (
        Path("/Applications/Microsoft PowerPoint.app/Contents/Resources/DFonts"),
        Path("/Applications/Microsoft Word.app/Contents/Resources/DFonts"),
        here / "fonts",
        root / "fonts",
    ):
        if candidate.is_dir():
            paths.append(str(candidate))
    font_args = [arg for path in dict.fromkeys(paths) for arg in ("--font-path", path)]

    try:
        fonts = subprocess.check_output(
            ["typst", "fonts", *font_args], text=True, encoding="utf-8"
        ).splitlines()
        if "Gill Sans MT" not in fonts:
            parser.error(
                "Gill Sans MT is required. Supply licensed fonts with --font-path "
                "or SLIDES_FONT_PATH. Gill Sans is a different family; "
                "no substitution was made."
            )
        output.parent.mkdir(parents=True, exist_ok=True)
        start = time.perf_counter()
        subprocess.run(
            ["typst", "watch" if args.watch else "compile", "--root", str(root),
             *font_args, str(source), str(output)],
            check=True,
        )
    except subprocess.CalledProcessError as error:
        return error.returncode
    except OSError as error:
        parser.error(str(error))
    except KeyboardInterrupt:
        return 130

    print(f"Built {output} ({time.perf_counter() - start:.2f}s)")
    return 0


if __name__ == "__main__":
    sys.exit(main())
