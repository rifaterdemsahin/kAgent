# Webapp Testing Skill

Load this skill when testing any web UI this project exposes (e.g. a kagent dashboard reached via `kubectl port-forward`, or this repo's own GitHub Pages site) end-to-end in a browser.

## Purpose
Drive a real browser against a running local or deployed page, read console/network output, and verify behavior — beyond what static smoke tests (`5_Symbols/toolbox/smoke_test.py`) already cover.

## Source
Pulled from [anthropics/skills](https://github.com/anthropics/skills) `skills/webapp-testing/` — full guide and example scripts vendored at [`.claude/skills/webapp-testing/`](../../.claude/skills/webapp-testing/SKILL.md) (server lifecycle helper, console-log capture, element discovery).

## When It Applies Here
- kagent typically exposes a UI/API inside the cluster — after `kubectl port-forward`, use this skill's patterns to check it loads and the sample agent's status renders without console errors.
- Complements `5_Symbols/toolbox/smoke_test.py` (SPEC-008), which only checks this repo's own static Pages site.

## Rules
- Start the target server/port-forward, wait for readiness, then drive the browser — don't guess timing with a fixed sleep.
- Capture console errors as part of the test result, not just a visual pass.
