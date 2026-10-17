"""User-facing behavior checks; no third-party Python packages required."""

from contextlib import redirect_stderr
import importlib.util
import io
import json
import os
from pathlib import Path
import shutil
import subprocess
import sys
import tempfile
import unittest
from unittest.mock import patch


REPO = Path(__file__).resolve().parents[1]
spec = importlib.util.spec_from_file_location("slide_build", REPO / "build.py")
BUILD = importlib.util.module_from_spec(spec)
spec.loader.exec_module(BUILD)


class CommandLineTests(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory(prefix="academic-template-")
        self.addCleanup(self.temp.cleanup)
        self.root = Path(self.temp.name)

    def generate(self, destination, *args):
        return subprocess.run(
            [sys.executable, str(REPO / "new-talk.py"), str(destination), *args],
            capture_output=True, text=True, encoding="utf-8", check=False,
        )

    def test_user_text_is_escaped_once(self):
        title = 'A "[Research group / University]" result\nwith $x$ 与中文'
        destination = self.root / "talk with spaces"
        result = self.generate(destination, "--title", title, "--system", 'A "system"')
        self.assertEqual(result.returncode, 0, result.stderr)
        text = (destination / "main.typ").read_text(encoding="utf-8")
        self.assertIn(json.dumps(title, ensure_ascii=False), text)
        self.assertIn(json.dumps('A "system"'), text)
        self.assertTrue((destination / "template" / "LICENSE").is_file())
        self.assertTrue((destination / ".gitignore").is_file())

    def test_existing_destination_is_untouched(self):
        destination = self.root / "existing"
        destination.mkdir()
        marker = destination / "keep.txt"
        marker.write_text("keep me", encoding="utf-8")
        result = self.generate(destination)
        self.assertNotEqual(result.returncode, 0)
        self.assertIn("already exists", result.stderr)
        self.assertNotIn("Traceback", result.stderr)
        self.assertEqual(marker.read_text(encoding="utf-8"), "keep me")
        self.assertEqual(list(destination.iterdir()), [marker])

    def test_missing_source_has_a_clear_error(self):
        errors = io.StringIO()
        with redirect_stderr(errors), self.assertRaises(SystemExit) as error:
            BUILD.main([str(self.root / "missing.typ")])
        self.assertEqual(error.exception.code, 2)
        self.assertIn("source file does not exist", errors.getvalue())
        self.assertFalse((self.root / "build").exists())

    def test_output_cannot_overwrite_source(self):
        source = self.root / "main.typ"
        source.write_text("Original source", encoding="utf-8")
        with redirect_stderr(io.StringIO()), self.assertRaises(SystemExit):
            BUILD.main([str(source), "--output", str(source)])
        self.assertEqual(source.read_text(encoding="utf-8"), "Original source")

    def test_gill_sans_is_not_silently_used_instead_of_gill_sans_mt(self):
        source = self.root / "main.typ"
        source.write_text("Content", encoding="utf-8")
        errors = io.StringIO()
        with (
            patch.object(BUILD.shutil, "which", return_value="typst"),
            patch.object(BUILD.subprocess, "check_output", return_value="Arial\nGill Sans\n"),
            patch.object(BUILD.subprocess, "run") as compile_call,
            redirect_stderr(errors),
            self.assertRaises(SystemExit),
        ):
            BUILD.main([str(source)])
        self.assertIn("Gill Sans MT is required", errors.getvalue())
        compile_call.assert_not_called()
        self.assertFalse((self.root / "build").exists())

    @unittest.skipUnless(
        os.environ.get("SLIDES_RUN_INTEGRATION") == "1",
        "set SLIDES_RUN_INTEGRATION=1 with Typst and Gill Sans MT installed",
    )
    def test_generated_talk_compiles_after_original_template_is_removed(self):
        copied = self.root / "original template"
        copied.mkdir()
        for name in ("new-talk.py", "build.py", "lib.typ", "starter.typ",
                     "AGENT.md", "LICENSE", ".gitignore"):
            shutil.copy2(REPO / name, copied / name)
        talk = self.root / "independent talk"
        subprocess.run(
            [sys.executable, str(copied / "new-talk.py"), str(talk),
             "--title", 'A "quoted" title', "--system", "Demo System"],
            check=True, capture_output=True,
        )
        shutil.rmtree(copied)
        result = subprocess.run(
            [sys.executable, str(talk / "build.py")], cwd=talk,
            capture_output=True, text=True, encoding="utf-8", check=False,
        )
        self.assertEqual(result.returncode, 0, result.stderr)
        output = talk / "build" / "main.pdf"
        self.assertTrue(output.read_bytes().startswith(b"%PDF"))
        self.assertFalse((talk / "main.pdf").exists())


if __name__ == "__main__":
    unittest.main()
