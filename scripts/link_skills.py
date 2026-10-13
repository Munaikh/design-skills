#!/usr/bin/env python3
"""Link this checkout's skills into ~/.agents/skills without replacing files."""
import argparse
import json
from pathlib import Path

from sync_references import MANIFEST, ROOT, check_or_write


def link_skills(destination, write=False):
    destination = destination.expanduser().resolve()
    if destination.is_relative_to(ROOT / 'skills'):
        raise ValueError('Destination must be outside the source skill folders')

    errors = check_or_write()
    sources = []
    for name in json.loads(MANIFEST.read_text())['skills']:
        if Path(name).name != name or name in {'.', '..'}:
            raise ValueError(f'Invalid skill folder: {name}')
        source = ROOT / 'skills' / name
        target = destination / name
        if not (source / 'SKILL.md').is_file():
            errors.append(f'{source}: missing SKILL.md')
        elif target.is_symlink() and target.resolve() == source.resolve():
            continue
        elif target.exists() or target.is_symlink():
            errors.append(f'{target}: already exists and is not linked to {source}; '
                          'preserve it elsewhere before installing')
        elif write:
            sources.append((source, target))
        else:
            errors.append(f'{target}: missing link to {source}')

    # Preflight the entire catalog before creating any links.
    if errors:
        return errors
    if write:
        destination.mkdir(parents=True, exist_ok=True)
        for source, target in sources:
            target.symlink_to(source, target_is_directory=True)
            print(f'LINK: {target} -> {source}')
    return []


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    mode = parser.add_mutually_exclusive_group(required=True)
    mode.add_argument('--write', action='store_true', help='Create missing skill links')
    mode.add_argument('--check', action='store_true', help='Verify links without writing')
    parser.add_argument('--dest', type=Path, default=Path.home() / '.agents/skills',
                        help='Skill directory (default: ~/.agents/skills)')
    args = parser.parse_args()
    try:
        errors = link_skills(args.dest, args.write)
    except (OSError, ValueError) as error:
        raise SystemExit(str(error)) from error
    if errors:
        raise SystemExit('\n'.join(errors))
    print('PASS: all declared skills link to this checkout; packaged references match')


if __name__ == '__main__':
    main()
