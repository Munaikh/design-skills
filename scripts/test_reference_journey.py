#!/usr/bin/env python3
"""Marionette smoke runner for the local reference app.

This exercises deterministic fixture data through the Flutter fallback chrome,
not a user's product or live data. Native UIKit navigation on supported iOS
needs native UI automation or manual interaction combined with Marionette;
its bar items are not Flutter key selectors.
Run the app on the intended device first, then pass its current VM service URI.
Marionette gestures are runtime smoke evidence, not deterministic CI tests.
"""
from __future__ import annotations

import argparse
import json
import re
import shutil
import subprocess
import sys
import time
from datetime import datetime, timezone
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
APP = ROOT / "validation/reference_app"


class Journey:
    def __init__(self, args: argparse.Namespace):
        self.args = args
        self.output = args.output.resolve()
        self.output.mkdir(parents=True, exist_ok=False)
        self.actions: list[dict] = []
        self.checks: list[dict] = []
        self.images: list[str] = []
        self.before_logs = ""
        self.server_steps: list[str] = []
        self.started = False

    def run(self, *command: str) -> str:
        index = len(self.actions) + 1
        title = f"Reference mobile journey {index:03d}"
        previous_sessions = set((self.output / ".marionette/sessions").glob("*/steps.md"))
        argv = [self.args.dart, "run", "marionette_cli:marionette",
                "--uri", self.args.uri, "--timeout", "15",
                "--session", title,
                "--session-dir", str(self.output), *command]
        # Never persist the VM service URI/token or print the full command.
        completed = subprocess.run(argv, cwd=APP, text=True, capture_output=True,
                                   timeout=90, check=False)
        result = (completed.stdout + completed.stderr).replace(self.args.uri, "<VM URI>")
        result = re.sub(r"(?:ws|http)://127\.0\.0\.1:\d+/[^\s]+", "<VM URI>", result)
        filename = f"{index:03d}-{command[0]}.txt"
        (self.output / filename).write_text(result)
        # The bridge prunes old sessions. Copy its actual step log immediately,
        # without modifying server-owned steps.md or estimating the count.
        for path in set((self.output / ".marionette/sessions").glob("*/steps.md")) - previous_sessions:
            recorded = path.read_text()
            (self.output / f"{index:03d}-server-steps.md").write_text(recorded)
            self.server_steps.extend(line for line in recorded.splitlines() if line.startswith("- ["))
        self.actions.append({"step": index, "command": list(command),
                             "exit_code": completed.returncode, "evidence": filename})
        (self.output / "commands.json").write_text(json.dumps(self.actions, indent=2) + "\n")
        if completed.returncode:
            raise RuntimeError(f"{command[0]} failed; see {filename}: {result.strip()[-600:]}")
        return result

    def inspect(self) -> str:
        return self.run("get-interactive-elements")

    def expect(self, name: str, *contents: str) -> str:
        end = time.monotonic() + 12
        while True:
            screen = self.inspect()
            if all(content in screen for content in contents):
                self.checks.append({"check": name, "evidence": self.actions[-1]["evidence"]})
                print(f"PASS: {name}", flush=True)
                return screen
            if time.monotonic() > end:
                native_hint = (
                    " Native UIKit bar items require native UI automation; "
                    "this runner targets Flutter fallback chrome."
                    if name in {"Control available: test_scenarios", "Control available: back_to_list"}
                    else ""
                )
                raise AssertionError(f"{name}: missing {contents!r}; see {self.actions[-1]['evidence']}.{native_hint}")
            time.sleep(0.3)

    def tap(self, key: str, *, scroll: bool = False) -> None:
        if scroll:
            self.run("scroll-to", "--key", key)
        self.expect(f"Control available: {key}", f'Key: "{key}"')
        self.run("tap", "--key", key)

    def fixture(self, name: str) -> None:
        screen = self.inspect()
        if 'Key: "fixture_demo"' not in screen:
            self.tap("test_scenarios")
        self.tap(f"fixture_{name}")

    def enter_note(self, value: str) -> None:
        self.run("scroll-to", "--key", "place_note")
        self.expect("Note input is reachable", 'Key: "place_note"')
        self.run("enter-text", "--key", "place_note", "--input", value)
        self.expect("Entered note is visible in the field", f'Text: "{value}"')

    def image(self, name: str) -> None:
        filename = f"{name}.png"
        self.run("take-screenshots", "--output", str(self.output / filename))
        if not (self.output / filename).is_file():
            raise AssertionError(f"Screenshot missing: {filename}")
        self.images.append(filename)

    def scenario(self) -> None:
        screen = self.inspect()
        if any(f'Key: "{key}"' in screen for key in ("native_navigation_bar", "native_tabs")):
            raise RuntimeError(
                "Native UIKit chrome detected. This runner targets Flutter fallback chrome; "
                "use native UI automation or manual interaction combined with Marionette."
            )
        self.started = True
        self.run("set-device-config", "--reset")
        self.before_logs = self.run("get-logs")
        self.fixture("demo")
        self.expect("Discover is loaded", 'Key: "place_garden"', "Make room for a small adventure.")
        self.image("01-discover")
        self.tap("place_garden")
        self.expect("Garden details opened", "A note for your next visit", 'Key: "place_note"')
        self.enter_note("Bring a book on Saturday.")
        self.tap("save_place", scroll=True)
        self.expect("Save completion is visible", "Saved to your places")
        self.image("02-saved-detail")
        self.tap("view_saved", scroll=True)
        self.expect("Saved list contains the saved note", "Good places, kept close.", "Bring a book on Saturday.")
        self.tap("place_garden", scroll=True)
        self.enter_note("Bring a book and a picnic.")
        self.tap("save_place", scroll=True)
        self.expect("Updated note saved", "Saved to your places")
        self.tap("back_to_list")
        self.expect("Back returns to Saved with the updated note", "Good places, kept close.", "Bring a book and a picnic.")
        self.image("03-updated-saved-list")

        self.fixture("loadFailure")
        self.expect("Load failure offers recovery", "Places could not load", 'Key: "retry_load"')
        self.image("04-load-recovery")
        self.tap("retry_load")
        self.expect("Load retry restores places", 'Key: "place_garden"', "Make room for a small adventure.")

        self.fixture("saveFailure")
        self.expect("Save failure fixture is ready", 'Key: "place_garden"')
        self.tap("place_garden")
        self.enter_note("Keep this note during retry.")
        self.tap("save_place", scroll=True)
        self.run("scroll-to", "--key", "place_note")
        self.expect("Save failure retains the draft and explains recovery", "Your place was not saved.", "Keep this note during retry.")
        self.image("05-save-recovery")
        self.tap("save_place", scroll=True)
        self.expect("Save retry completes", "Saved to your places")
        self.tap("view_saved", scroll=True)
        self.expect("Retained draft becomes the saved note", "Good places, kept close.", "Keep this note during retry.")

        self.fixture("empty")
        self.expect("Empty content gives a next step", "No places found", 'Key: "empty_action"')
        self.image("06-empty-places")

        self.fixture("demo")
        self.expect("Appearance sweep starts from Discover", 'Key: "place_garden"')
        self.run("set-device-config", "--text-scale", "2.0", "--bold-text", "true", "--platform-brightness", "dark")
        self.expect("Large text Discover remains reachable", "Make room for a small adventure.")
        self.image("07-large-text-dark-discover")
        self.tap("place_garden", scroll=True)
        self.enter_note("Large text can still complete this task.")
        self.tap("save_place", scroll=True)
        self.expect("Large text save completes", "Saved to your places")
        self.image("08-large-text-dark-save")
        self.tap("view_saved", scroll=True)
        # Centering the tall tile at 2x leaves its subtitle below the viewport.
        # Scroll to the actual result text, not merely its surrounding tile.
        self.run("scroll-to", "--text", "Southside · Quiet outdoors\nLarge text can still complete this task.")
        self.expect("Large text Saved contains the result", "Large text can still complete this task.")
        self.image("09-large-text-dark-saved")
        logs = self.run("get-logs")
        # Logs persist across CLI calls; compare with the pre-run baseline.
        previous = set(self.before_logs.splitlines())
        fresh = "\n".join(line for line in logs.splitlines() if line not in previous)
        (self.output / "new-runtime-logs.txt").write_text(fresh + "\n")
        self.checks.append({"check": "Runtime logs collected", "evidence": "new-runtime-logs.txt"})
        if re.search(r"overflowed by|EXCEPTION CAUGHT|Unhandled Exception|Assertion failed", fresh, re.I):
            raise AssertionError("Runtime diagnostics contain a Flutter error; see new-runtime-logs.txt")

    def finish(self, failure: str | None) -> None:
        cleanup_errors = []
        if self.started:
            try:
                self.run("set-device-config", "--reset")
            except Exception as error:
                cleanup_errors.append(str(error))
            try:
                self.fixture("demo")
                self.expect("Fixture and device overrides restored", 'Key: "place_garden"')
            except Exception as error:
                cleanup_errors.append(str(error))
        if cleanup_errors:
            failure = (failure or "") + " Cleanup: " + "; ".join(cleanup_errors)
        server_lines = len(self.server_steps)
        verdict = "FAIL" if failure else "PASS"
        headline = "⚠️" if failure else "✅"
        report = [f"{headline} Marionette report — {verdict} · Discover and save a place",
                  f"Device: {self.args.device}",
                  f"Date: {datetime.now(timezone.utc).isoformat()}",
                  f"Tested: {len(self.actions)} recorded CLI commands; {server_lines} server step-log lines; {len(self.images)} screenshots.",
                  "Bridge: project-local marionette_cli/flutter 0.7.0.", ""]
        if failure:
            report += [f"⚠️ [suspicion] {failure}", "A failed smoke command/postcondition needs inspection; it alone does not classify an app bug.", ""]
        for check in self.checks:
            report.append(f"- ✅ {check['check']} — {check['evidence']}")
        report += ["", "Screenshots: " + ", ".join(self.images), "",
                   "➖ Not covered: Android, hardware fold posture, physical gestures/haptics, VoiceOver/TalkBack, native permission UI, performance profiling.",
                   "Text entry uses Marionette's field simulation. It does not validate a physical software keyboard.",
                   "This runner does not validate UIKit bar-item activation, native popup internals, or native chrome screenshots.",
                   "The report establishes in-memory fixture behavior; it does not assert storage across app restarts."]
        (self.output / "report.md").write_text("\n".join(report) + "\n")
        print(f"Marionette · Discover and save — {verdict}", flush=True)
        print(f"Report: {self.output / 'report.md'}", flush=True)
        if failure:
            raise SystemExit(1)


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--uri", required=True, help="Current target app VM service WebSocket URI; not saved in evidence")
    parser.add_argument("--output", required=True, type=Path, help="New evidence directory (must not already exist)")
    parser.add_argument("--dart", default=shutil.which("dart") or "dart", help="Project-compatible Dart executable")
    parser.add_argument("--device", default="Flutter fallback target", help="Actual target platform/device for the report")
    args = parser.parse_args()
    if not args.uri.startswith(("ws://", "wss://")):
        parser.error("--uri must be a VM service WebSocket URI")
    journey = Journey(args)
    failure = None
    try:
        journey.scenario()
    except (AssertionError, RuntimeError, subprocess.TimeoutExpired) as error:
        failure = str(error).replace(args.uri, "<VM URI>")
        print(f"FAIL: {failure}", file=sys.stderr, flush=True)
    finally:
        journey.finish(failure)


if __name__ == "__main__":
    main()
