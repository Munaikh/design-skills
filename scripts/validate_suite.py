#!/usr/bin/env python3
"""Read-only checks for independently installable Flutter mobile skills."""
from pathlib import Path
import re
import sys
from sync_references import check_or_write

ROOT = Path(__file__).resolve().parents[1]
AUTHOR = 'Abdullah AlMunaikh'
BAD_SUFFIXES = {'.js', '.jsx', '.ts', '.tsx', '.html', '.css', '.mjs', '.cjs'}
errors = []
skills = sorted((ROOT / 'skills').iterdir())
expected = {'flutter-mobile-design', 'flutter-ui-review', 'flutter-prototype', 'flutter-ios-swift'}
if {p.name for p in skills} != expected:
    errors.append('Skill catalog must contain exactly the four declared workflows')
errors.extend(check_or_write())

def fail(path, message):
    errors.append(f'{path.relative_to(ROOT)}: {message}')

for folder in skills:
    if not folder.is_dir():
        fail(folder, 'Unexpected file in skill catalog')
        continue
    path = folder / 'SKILL.md'
    if not path.exists():
        fail(folder, 'Missing SKILL.md')
        continue
    text = path.read_text()
    front = re.match(r'^---\n(.*?)\n---\n', text, re.S)
    if not front:
        fail(path, 'Invalid frontmatter')
        continue
    fields = front.group(1)
    if not re.search(r'^name: ' + re.escape(folder.name) + r'$', fields, re.M):
        fail(path, 'Name must match the installable folder')
    if not re.fullmatch(r'[a-z0-9]+(?:-[a-z0-9]+)*', folder.name) or len(folder.name) > 64:
        fail(path, 'Invalid skill name')
    if not re.search(r'^description: .+', fields, re.M):
        fail(path, 'Missing discovery description')
    if f'  author: {AUTHOR}' not in fields or AUTHOR not in text[front.end():]:
        fail(path, 'Missing modified-edition attribution')
    license_path = folder / 'LICENSE'
    if not license_path.exists() or license_path.read_text() != (ROOT / 'LICENSE').read_text():
        fail(folder, 'Missing or divergent MIT attribution')
    meta = folder / 'agents/openai.yaml'
    metadata = ''
    if not meta.exists():
        fail(folder, 'Missing invocation metadata')
    else:
        metadata = meta.read_text()
        if '$' + folder.name not in metadata:
            fail(meta, 'Default prompt must invoke this skill')
        short = re.search(r'  short_description: "(.*)"', metadata)
        if not short or not 25 <= len(short.group(1)) <= 64:
            fail(meta, 'Short description must be 25–64 characters')
    if 'allow_implicit_invocation: true' not in metadata:
        fail(meta, 'All workflows must support task discovery')
    # Keep shared implementation and visual policies discoverable in every bundle.
    policy_terms = (
        'Flutter Animate by default', 'AnimatedContainer', 'Motor', 'Heroine',
        'do not introduce stock Hero', 'Smooth Sheets', 'Motion',
        'very complex custom animation mixers',
        '(references/dart-engineering.md)', '(references/toolkit.md)',
        'no ink splashes or ripples', 'NoSplash.splashFactory',
        'unstyled stock Material', 'shadows restrained',
        '(references/theme-patterns.md)',
    )
    for term in policy_terms:
        if term not in text:
            fail(path, f'Missing shared implementation policy: {term}')
    for name in ('dart-engineering.md', 'toolkit.md', 'theme-patterns.md'):
        if not (folder / 'references' / name).is_file():
            fail(folder, f'Missing independently packaged policy guide: {name}')

for path in ROOT.rglob('*'):
    if any(part in {'.git', '.dart_tool', 'build', 'Pods', '.symlinks', '.marionette', '.idea', '__pycache__', 'reports'} for part in path.parts) or not path.is_file():
        continue
    if path.suffix in BAD_SUFFIXES:
        fail(path, 'Foreign-platform source file')
    if path.suffix != '.md':
        continue
    source = path.read_text()
    # Ignore documentation URL extensions; scan visible prose and code.
    visible = re.sub(r'https?://[^\s)>]+', '', source)
    # Migration context may discuss web interfaces. Authored implementation
    # instructions must not carry over another platform's APIs or snippets.
    technical = re.compile(r'\b(?:JavaScript|TypeScript|React|Expo|CSS|HTML|JSX|TSX|Tailwind|Framer|Sonner|npm|npx|WAAPI|PWA|Zustand)\b|setPointerCapture|IntersectionObserver|next-themes|dangerouslySetInnerHTML', re.I)
    for hit in technical.finditer(visible):
        fail(path, f'Foreign implementation guidance {hit.group()!r}')
    fence = None
    for line_no, line in enumerate(source.splitlines(), 1):
        match = re.match(r'^\s*(`{3,}|~{3,})(.*)$', line)
        if not match:
            continue
        marker, language = match.groups()
        if fence is None:
            fence = marker
            if language.strip() not in {'', 'dart', 'swift', 'text', 'markdown', 'bash', 'yaml', 'json'}:
                fail(path, f'Unexpected fence language at line {line_no}: {language}')
        elif marker[0] == fence[0] and len(marker) >= len(fence) and not language.strip():
            fence = None
    if fence:
        fail(path, 'Unclosed code fence')
    for match in re.finditer(r'\[[^\]\n]+\]\(([^)]+)\)', source):
        target = match.group(1)
        if '://' in target or target.startswith('#'):
            continue
        relative = target.split('#')[0]
        resolved = (path.parent / relative).resolve()
        if not resolved.exists():
            fail(path, f'Broken local reference: {target}')
        if 'skills' in path.parts:
            folder = ROOT / 'skills' / path.relative_to(ROOT / 'skills').parts[0]
            if not resolved.is_relative_to(folder):
                fail(path, f'Reference escapes installable skill: {target}')

if errors:
    print('\n'.join(errors))
    sys.exit(1)
print(f'PASS: {len(skills)} independently installable Flutter mobile skills; structure, references, fences, attribution, metadata, and content checks.')
