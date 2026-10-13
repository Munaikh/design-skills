#!/usr/bin/env python3
"""Exercise portable packaging, drift detection and non-destructive installation."""
import shutil
import json
import re
import subprocess
import sys
import tempfile
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]


class PackagingTests(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory(prefix='flutter-skill-packaging-')
        self.addCleanup(self.temp.cleanup)
        self.root = Path(self.temp.name) / 'suite'
        self.root.mkdir()
        for name in ('skills', 'references', 'scripts'):
            shutil.copytree(ROOT / name, self.root / name,
                            ignore=shutil.ignore_patterns('__pycache__'))
        for name in ('LICENSE', 'LICENSE-Appllama'):
            shutil.copy2(ROOT / name, self.root / name)

    def run_script(self, script, *args):
        return subprocess.run([sys.executable, str(self.root / 'scripts' / script), *args],
                              capture_output=True, text=True, check=False)

    def test_portable_bundle_and_manifest_catalog(self):
        result = self.run_script('validate_suite.py')
        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
        shutil.rmtree(self.root / 'skills/flutter-research-design')
        self.assertNotEqual(self.run_script('validate_suite.py').returncode, 0)

    def test_stale_reference_detected_and_repaired(self):
        target = self.root / 'skills/flutter-research-design/references/appllama-research.md'
        target.write_text('stale copy\n')
        self.assertNotEqual(self.run_script('sync_references.py', '--check').returncode, 0)
        self.assertEqual(self.run_script('sync_references.py', '--write').returncode, 0)
        self.assertEqual(self.run_script('validate_suite.py').returncode, 0)

    def test_missing_upstream_notice_fails(self):
        (self.root / 'skills/flutter-research-design/LICENSE-Appllama').unlink()
        result = self.run_script('validate_suite.py')
        self.assertNotEqual(result.returncode, 0)
        self.assertIn('license notice', result.stdout)

    def test_motion_guide_cannot_be_dropped_from_bundle_and_manifest(self):
        # Even internally consistent packaging must retain the core guide.
        manifest_path = self.root / 'references/manifest.json'
        manifest = json.loads(manifest_path.read_text())
        manifest['skills']['flutter-research-design'].remove('motion-patterns.md')
        manifest_path.write_text(json.dumps(manifest))
        (self.root / 'skills/flutter-research-design/references/motion-patterns.md').unlink()
        result = self.run_script('validate_suite.py')
        self.assertNotEqual(result.returncode, 0)
        self.assertIn('Missing independently packaged policy guide: motion-patterns.md', result.stdout)

    def test_core_guidance_must_be_reachable_from_entrypoint(self):
        path = self.root / 'skills/flutter-mobile-design/SKILL.md'
        path.write_text(re.sub(r'\[([^\]]+)\]\(references/mobile-ux\.md\)',
                               r'\1', path.read_text()))
        result = self.run_script('validate_suite.py')
        self.assertNotEqual(result.returncode, 0)
        self.assertIn('Missing required guidance link: mobile-ux.md', result.stdout)

    def test_generated_evidence_cannot_ship(self):
        folder = self.root / 'skills/flutter-research-design/research'
        folder.mkdir()
        (folder / 'capture.png').write_bytes(b'not a production asset')
        result = self.run_script('validate_suite.py')
        self.assertNotEqual(result.returncode, 0)
        self.assertIn('must not ship', result.stdout)

    def test_generated_app_launchers_are_not_skill_content(self):
        for directory in ('validation/apps/to_do/web', 'validation/reference_app/web'):
            folder = self.root / directory
            folder.mkdir(parents=True)
            (folder / 'index.html').write_text('<html></html>')
        result = self.run_script('validate_suite.py')
        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
        # The exclusion must not weaken checks inside portable skill bundles.
        (self.root / 'skills/flutter-research-design/index.html').write_text('<html></html>')
        result = self.run_script('validate_suite.py')
        self.assertNotEqual(result.returncode, 0)
        self.assertIn('Foreign-platform source file', result.stdout)

    def test_install_is_idempotent_and_preserves_conflicts(self):
        destination = Path(self.temp.name) / 'installed'
        result = self.run_script('link_skills.py', '--write', '--dest', str(destination))
        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
        self.assertTrue((destination / 'flutter-research-design').is_symlink())
        self.assertEqual(self.run_script('link_skills.py', '--write', '--dest', str(destination)).returncode, 0)
        self.assertEqual(self.run_script('link_skills.py', '--check', '--dest', str(destination)).returncode, 0)
        target = destination / 'flutter-research-design'
        target.unlink()
        target.mkdir()
        sentinel = target / 'user-owned.txt'
        sentinel.write_text('preserve me')
        self.assertNotEqual(self.run_script('link_skills.py', '--write', '--dest', str(destination)).returncode, 0)
        self.assertEqual(sentinel.read_text(), 'preserve me')


if __name__ == '__main__':
    unittest.main()
