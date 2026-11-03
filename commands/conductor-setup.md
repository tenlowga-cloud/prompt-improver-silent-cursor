---
name: conductor-setup
description: Re-run the first-run setup for the silent prompt gate (models, plan, budget, GitHub, Grok Bot link).
---

Read the skill `prompt-improver-silent-cursor` and run `references/setup.md`. If a config exists, show it in a few lines and ask which step to redo, one question at a time. Nothing else needs this command; the gate runs on every prompt by itself.
