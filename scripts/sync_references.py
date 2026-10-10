#!/usr/bin/env python3
"""Package declared local reference copies; author: Abdullah AlMunaikh."""
import argparse
import json
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
MANIFEST = ROOT / 'references/manifest.json'


def check_or_write(write=False):
    manifest = json.loads(MANIFEST.read_text())
    problems = []
    declared = set()
    for skill, names in manifest['skills'].items():
        destination = ROOT / 'skills' / skill / 'references'
        if write:
            destination.mkdir(parents=True, exist_ok=True)
        for name in names:
            if Path(name).name != name or not name.endswith('.md'):
                raise ValueError(f'Invalid reference filename: {name}')
            declared.add(name)
            original = ROOT / 'references' / name
            target = destination / name
            if write:
                target.write_bytes(original.read_bytes())
            elif target.is_symlink() or not target.exists() or target.read_bytes() != original.read_bytes():
                problems.append(f'{skill}/{name}: missing, linked, or stale packaged copy')
        # Never delete unknown local files automatically.
        extras = {p.name for p in destination.glob('*.md')} - set(names)
        problems.extend(f'{skill}/{name}: undeclared packaged reference' for name in sorted(extras))
    extras = {p.name for p in (ROOT / 'references').glob('*.md')} - declared
    problems.extend(f'{name}: source reference has no consuming skill' for name in sorted(extras))
    return problems


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description=__doc__)
    mode = parser.add_mutually_exclusive_group(required=True)
    mode.add_argument('--write', action='store_true')
    mode.add_argument('--check', action='store_true')
    args = parser.parse_args()
    errors = check_or_write(args.write)
    if errors:
        raise SystemExit('\n'.join(errors))
    print('PASS: declared references ' + ('synchronized' if args.write else 'match their source'))
