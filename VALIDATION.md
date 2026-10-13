# Validation

The suite contains five independently installable skills. Start with flutter-research-design for research-led design/build work; the other workflows have focused roles described in the README. Structural checks verify packaging, not design quality.

## Reproduce packaging checks

```bash
python3 scripts/sync_references.py --check
python3 scripts/validate_suite.py
python3 scripts/test_skill_packaging.py
python3 scripts/link_skills.py --check
```

Run the skill-creator `quick_validate.py` for each skill using a Python environment with PyYAML. The packaging tests use isolated temporary copies to check portability, source/copy drift and repair, upstream license retention, accidental evidence directories, and non-destructive/idempotent installation. The catalog is manifest-driven. Bundles retain their complete local guides and relevant license notices.

For changed Dart examples, use `python3 scripts/check_examples.py --flutter /path/to/project-pinned/flutter`. Optional dependency examples remain in `validation/package_examples`; run their own analyze/tests when changing those examples. The optional examples are separate from manually generated reference apps.

## Manual app trials

Use the short [to-do app prompt](validation/reference-app-prompt.md) with any agent you prefer. Choose the skill separately and ask the agent to put its output in `validation/reference_app/`. This repository does not bundle a reference app or prescribe a model, agent dispatch, or trial history.

Run the generated app's own analysis and tests, inspect it on the intended devices, and assess onboarding, task management, navigation and local persistence. Keep screenshots, recordings and logs outside the repository. Record only the results you need; previous app results do not validate a newly generated app.

## Evidence boundaries

Keep routine results in chat and this file concise. Automatic Marionette session reports are disabled by default; opt in only for a specific investigation. Runtime evidence is temporary and is not shipped with the skills.

Widget tests can exercise state, recovery and synthetic layout configurations. They do not establish native control behavior, assistive traversal, physical fold posture, actual keyboard animation, haptics or sustained device performance. Marionette covers Flutter content; native UIKit controls need native automation and full-device captures. Debug simulator recordings do not establish profile/release performance. Report each unavailable check explicitly.
