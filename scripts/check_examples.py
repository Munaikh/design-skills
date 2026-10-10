#!/usr/bin/env python3
"""Extract unique complete Dart examples into an isolated SDK-only package."""
from pathlib import Path
import argparse
import hashlib
import re
import subprocess
import tempfile

ROOT = Path(__file__).resolve().parents[1]
parser = argparse.ArgumentParser()
parser.add_argument('--flutter', default='flutter', help='Project-pinned Flutter executable')
args = parser.parse_args()
workspace = Path(tempfile.mkdtemp(prefix='flutter-design-examples-'))
(workspace / 'lib').mkdir()
(workspace / 'test').mkdir()
(workspace / 'pubspec.yaml').write_text('''name: flutter_design_examples
publish_to: none
environment:
  sdk: '>=3.0.0 <4.0.0'
dependencies:
  flutter:
    sdk: flutter
dev_dependencies:
  flutter_test:
    sdk: flutter
''')
seen = set()
manifest = []
for path in sorted((ROOT / 'references').glob('*.md')):
    for number, block in enumerate(re.findall(r'^```dart\n(.*?)^```\s*$', path.read_text(), re.S | re.M), 1):
        digest = hashlib.sha256(block.encode()).hexdigest()
        if digest in seen:
            continue
        seen.add(digest)
        primary = re.search(r'^(?:abstract final )?class (\w+)', block, re.M)
        if primary:
            filename = re.sub(r'(?<!^)(?=[A-Z])', '_', primary.group(1)).lower() + '.dart'
        else:
            filename = 'tokens_' + digest[:10] + '.dart'
        if not re.search(r'^import ', block, re.M):
            if primary and primary.group(1) in {'LatestRequest', 'ThresholdGate'}:
                pass  # Pure Dart helpers need no framework import.
            else:
                block = "import 'package:flutter/animation.dart';\n\n" + block
        destination = workspace / 'lib' / filename
        if destination.exists():
            raise RuntimeError(f'Duplicate example class in {path}')
        destination.write_text(block)
        manifest.append(f'{filename}: {path.relative_to(ROOT)} block {number}')
(workspace / 'EXAMPLES.txt').write_text('\n'.join(manifest) + '\n')
(workspace / 'test' / 'recipes_test.dart').write_text((ROOT / 'validation/recipes_test.dart').read_text())
print(f'Validating {len(seen)} unique Dart blocks in {workspace}', flush=True)
for command in [['pub', 'get', '--offline'], ['analyze'], ['test']]:
    subprocess.run([args.flutter, *command], cwd=workspace, check=True)
print(f'PASS: analysis and behavior tests. Retained isolated evidence at {workspace}')
