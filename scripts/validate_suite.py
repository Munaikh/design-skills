#!/usr/bin/env python3
"""Read-only checks for independently installable Flutter mobile skills."""
from pathlib import Path
import json
import re
import sys
from sync_references import check_or_write

ROOT = Path(__file__).resolve().parents[1]
AUTHOR = 'Abdullah'
BAD_SUFFIXES = {'.js', '.jsx', '.ts', '.tsx', '.html', '.css', '.mjs', '.cjs'}
errors = []
skills = sorted((ROOT / 'skills').iterdir())
expected = set(json.loads((ROOT / 'references/manifest.json').read_text())['skills'])
if {p.name for p in skills} != expected:
    errors.append('Skill catalog must match the manifest workflows')
errors.extend(check_or_write())

def fail(path, message):
    errors.append(f'{path.relative_to(ROOT)}: {message}')

for folder in skills:
    if not folder.is_dir():
        fail(folder, 'Unexpected file in skill catalog')
        continue
    for artifact in folder.rglob('*'):
        if any(part in {'research', 'reports', '.marionette', '.design-evidence', '.research-cache'} for part in artifact.relative_to(folder).parts):
            fail(artifact, 'Generated research/runtime evidence must not ship in skill bundles')
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
    if f'  author: {AUTHOR}' not in fields:
        fail(path, 'Missing maintainer metadata')
    if 'Emil Kowalski' not in text[front.end():]:
        fail(path, 'Missing original-source attribution')
    license_path = folder / 'LICENSE'
    if not license_path.exists() or license_path.read_text() != (ROOT / 'LICENSE').read_text():
        fail(folder, 'Missing or divergent MIT attribution')
    if folder.name == 'flutter-research-design':
        notice = folder / 'LICENSE-Appllama'
        if not notice.is_file() or notice.read_bytes() != (ROOT / 'LICENSE-Appllama').read_bytes():
            fail(folder, 'Missing Appllama upstream license notice')
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
    # Check access to canonical guidance, not repeated policy wording.
    # These structural checks cannot establish an agent's design quality.
    required_guides = {'dart-engineering.md', 'toolkit.md', 'theme-patterns.md'}
    if folder.name != 'flutter-ios-swift':
        required_guides.update({'motion-patterns.md', 'mobile-ux.md'})
    linked_guides = set(re.findall(r'\]\(references/([^)#]+)(?:#[^)]*)?\)', text))
    for name in sorted(required_guides):
        if name not in linked_guides:
            fail(path, f'Missing required guidance link: {name}')
        if not (folder / 'references' / name).is_file():
            fail(folder, f'Missing independently packaged policy guide: {name}')

for path in ROOT.rglob('*'):
    relative = path.relative_to(ROOT)
    # User-generated app trials are not distributed skill content. Flutter
    # scaffolds can legitimately contain other platform launchers and assets.
    if relative.parts[:2] in {('validation', 'apps'), ('validation', 'reference_app')}:
        continue
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
        if resolved.is_relative_to(ROOT / 'validation' / 'reports'):
            fail(path, f'Local evidence link is not shipped; use a plain local artifact path: {target}')
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
