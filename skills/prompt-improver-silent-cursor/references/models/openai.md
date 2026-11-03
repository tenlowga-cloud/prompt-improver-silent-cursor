---
family: OpenAI text (GPT-6 Astra, GPT-5.6, Codex, ChatGPT)
verified: 2026-09-09
---
# Prompting card — OpenAI

> **Cursor note (2026-11-03).** Cursor offers GPT-5.6 Sol, Terra and Luna plus older GPT-5.x. GPT-6 Astra is not in Cursor's list. OpenAI proposed ending Cursor's access on 2026-11-12, so GPT is a backup lane only in this skill. Sections 1 to 6 still apply when a GPT model runs a slice.

Sources fetched 2026-09-03: OpenAI "A builder's guide to GPT-5.6" (openai.com blocks plain fetch), the OpenAI developer docs (prompt engineering, Responses API, prompt caching, model pages, Codex AGENTS.md and personalization). Sources fetched 2026-09-09: "Using GPT-6 Astra" model guidance, the gpt-6-astra model page, the reasoning guide, the September 2026 changelog, the Astra system card, and Codex's local model list with its bundled Astra instruction template. Section 9 is the Astra card; sections 1 to 8 remain true for the GPT-5.6 family and the Codex surface.

**1. Models and when to use which**
- **GPT-6 Astra** (`gpt-6-astra`, released 2026-09-02): OpenAI's most capable model; the default for new API work and in Codex. Context 1.05M tokens, max input 922K, max output 128K, knowledge cutoff 2026-04-30. Effort `low` to `max`, no `none`. See section 9 before prompting it.
- `gpt-5.6` (alias) routes to **GPT-5.6 Sol** (`gpt-5.6-sol`): the strongest GPT-5.6, complex professional and agentic work; still the pinned heavy-lifting seat in `web-build` and `cross-vertical-copy-director`. Context 1.05M tokens, max output 128K, knowledge cutoff 2026-02-16.
- **GPT-5.6 Terra** (`gpt-5.6-terra`): mid-tier, strong cost/performance for most agent workloads.
- **GPT-5.6 Luna** (`gpt-5.6-luna`): smallest and cheapest, for high-volume, latency-sensitive, or repeated agentic steps (extraction, browsing, retrieval).
- Reasoning mode `standard` (default) vs `pro`, independent of `reasoning.effort`; `pro` does more work per request for hard tasks where quality matters most.
- **Codex** (CLI, IDE extension, cloud, GitHub review) is the coding-agent surface on GPT-5.6-family reasoning models; reads `AGENTS.md` chains before any work.
- **ChatGPT**: chat, Work mode (multi-step, tool-using), and "ultra" (native multi-agent orchestration under the hood).

**2. What changed vs the previous generation (5.5 / 5.4)**
- More concise by default. Re-check "be concise" instructions; they can now make answers too terse.
- Leaner prompts win. Internal coding-agent evals: trimming repeated instructions, examples, and tool descriptions improved scores about 10 to 15% while cutting tokens 41 to 66% (vendor figure; validate per workload).
- Reasoning persists across turns by default: `reasoning.context` defaults to `all_turns` (older models: `current_turn`).
- Lower effort goes further: 5.6 Sol at low reportedly beat 5.5 at high on Agents' Last Exam with the harness held constant (vendor claim).
- More proactive and persistent on multi-step tasks; autonomy and approval boundaries must now be stated explicitly.
- New agent primitives: persisted reasoning plus native compaction, native multi-agent orchestration, Programmatic Tool Calling (the model writes JS to orchestrate tools outside its context window).
- Effort values expanded to `none, minimal, low, medium, high, xhigh, max`, but per-model support varies; 5.6 Sol lists `none, low, medium (default), high, xhigh, max` with no `minimal`. Check the model page.

**3. Prompt skeleton that works**
- Responses API roles: `developer` (stable instructions and reference material, first, static), `user` (the task), `assistant` (with `phase: "commentary"` for interim tool-call preambles vs `phase: "final_answer"` in long-running flows).
- Goal → constraints → explicit output contract, without over-prescribing intermediate steps.
- For ChatGPT and Codex generally: Goal, Context, Output, Boundaries; use only the parts that matter. Markdown headers, not XML.
- Put stable content first for caching; dynamic or user-specific content last or in later turns.

**4. Controls that shape output**
- `reasoning.effort`: `none | minimal | low | medium | high | xhigh | max` (model-dependent subset).
- `reasoning.mode`: `standard` (default) | `pro`.
- `reasoning.context`: `auto | current_turn | all_turns`; 5.6 defaults to `all_turns`; only reusable within the same model family.
- `reasoning.summary: auto` for an opt-in reasoning summary; raw reasoning tokens are never exposed.
- `text.verbosity`: `low | medium | high` (default `medium`).
- `max_output_tokens` caps reasoning plus visible plus formatting tokens; reserve 25,000 or more at first so reasoning does not eat the budget before any visible output.
- Prompt caching (5.6+): `prompt_cache_options.mode` = `implicit` / `explicit`, `prompt_cache_breakpoint`, `prompt_cache_options.ttl` (`"30m"` minimum), `prompt_cache_key` for routing. Minimum cacheable prefix 1,024 tokens on 5.6+ (2,048 older). Write 1.25x, read 0.1x the uncached rate.
- Structured Outputs: `text.format` with `{"type":"json_schema", ...}`; the legacy `{"type":"json_object"}` is deprecated.
- Programmatic Tool Calling: for bounded, deterministic processing stages only, not single calls or when each result changes the next decision.

**5. Do / Don't**
- Do state autonomy and approval boundaries once, explicitly (a 3-tier policy: answer or explain / change or build / external, destructive, or costly). Don't repeat "ask first" in several places; the repetition itself triggers needless approval requests.
- Do set `text.verbosity` plus task-specific length rules in the prompt. Don't reuse 5.5-era "be concise" phrasing without retesting.
- Do name safe local actions explicitly. Don't leave autonomy undefined and expect self-limiting.
- Do prune prompts one instruction, example, or tool group at a time against evals. Don't stack every historical instruction "just in case."
- Do put stable content first with an explicit breakpoint after it. Don't summarize or rewrite earlier turns if cache reuse matters; it resets the matching prefix.
- Do pin production prompts to specific model snapshots with an eval suite.

**6. Pitfalls**
- Anti-laziness and broad brevity instructions overtrigger now that 5.6 is concise by default.
- Repeated "don't do X" can cause needless stalls.
- A shared prefix is not a cached prefix without an explicit breakpoint after the static part.
- Compaction silently breaks cache reuse even in a "continuing" conversation.
- Reasoning does not carry across model families (5.5 ↔ 5.6).
- A missing `phase` on replayed assistant messages makes preambles read as final answers.
- Running out of `max_output_tokens` burns cost on reasoning with zero visible output.
- In Codex agent loops the bill is context × steps, not prompt length: a measured build run re-sent ~100k tokens per step for 21 steps (2026-09-03 benchmark); global `AGENTS.md` pointers that say "read X first" and actions the sandbox forbids (Slack, `.git` writes) are the real cost drivers. Cut pulls and dead steps before cutting prose.

**7. Agentic / coding specifics (Codex)**
- AGENTS.md discovery: global (`~/.codex/AGENTS.override.md`, else `AGENTS.md`; `CODEX_HOME` overridable) → project (walk Git root to cwd; override / normal / fallback names; one file per dir) → merged root-to-leaf; closer-to-cwd files win because they are appended later.
- 32 KiB combined cap (`project_doc_max_bytes`); raise or split if truncated.
- Verify with `codex --ask-for-approval never "Summarize the current instructions."`; audit via `-c log_dir=./.codex-log` or the session `*.jsonl`.
- Code-review rules go in a `## Code Review Rules` section of the nearest AGENTS.md; root = repo-wide, nested = service-specific.
- `project_doc_fallback_filenames` in `~/.codex/config.toml` for legacy names like `TEAM_GUIDE.md`.
- Patterns: `/plan` (investigate and propose before editing), `/goal` (persistent goal after the plan), `/review` (local diff, optional focus), `@codex review` (GitHub PR comment). In the CLI, `Enter` steers the current turn and `Tab` queues for the next.
- Good prompts name the behavior wanted, point to the code or repro steps, preserve constraints, and state verification; repro and constraints matter more than a high-level description.
- Sandboxed by default; crossing a file or network boundary triggers the approval policy; cloud tasks run internet-off during the agent phase unless enabled.

**8. ChatGPT / Codex custom-instructions specifics**
- ChatGPT's "custom instructions" IS Codex's global `AGENTS.md`: same mechanism ("Editing custom instructions updates your personal instructions in AGENTS.md").
- Personality (Friendly / Pragmatic / None) is a separate tone-only toggle.
- Memories are explicitly not for mandatory guidance; anything that must always apply goes in AGENTS.md or checked-in project docs.
- No character-limit figure was found in the docs (unverified). Keep a paste block under 1,500 characters as a safe floor.
- Project and repo-level AGENTS.md files layer on top of the global personal one per the discovery order above.

**9. GPT-6 Astra (`gpt-6-astra`, released 2026-09-02; sources fetched 2026-09-09)**

Astra is the strongest instruction-follower OpenAI has shipped, so a prompt for it is a short, clean work order, and every stale or contradictory line in reach becomes a real cost.

*Facts.* Context 1.05M tokens, max input 922K, max output 128K, cutoff 2026-04-30, text and image in. `reasoning.effort`: `low`, `medium`, `high`, `xhigh`, `max`; `none` returns HTTP 400. Codex adds `ultra` (max reasoning plus automatic delegation) and defaults to `medium`. No `temperature`, `top_p`, or logprobs. Tool calling needs the Responses API. Over 272K input tokens the whole request bills at 2x input and 1.5x output. New controls: async tool calls (`async: true`, result returned later by `call_id`), mid-turn steering over WebSockets, and `configuration_update` items to change effort mid-conversation without losing the cache. Reasoning persists across turns as on 5.6 (`reasoning.context` default `all_turns`).

*The five behaviors to prompt for, from OpenAI's guide.*
- **Initiative.** Astra asks more than Sol when input could change the result, and can stop where you expected it to assume and persist. Say once that it should infer intent and bias toward action, that "can you", "I want to", "help me" mean do the work, that it should finish authorized work and bring a concrete reviewable result before asking, and that reversible or read-only work needs no permission. Tell it not to add unsolicited warnings, disclaimers, approval flows, or safety checklists for hypothetical risk.
- **Instruction following.** It reads skills and `AGENTS.md` literally. A vague "needs approval" line makes it stop and wait. State that user instructions outrank skills, and add the debug line: if a skill makes you pause, name the exact SKILL.md, quote the instruction, and say whether it is a requirement or your interpretation. Audit and prune every instruction file it can reach; do not stack rules.
- **Writing style.** Defaults to lists, tables, Markdown, and recurring phrases. For prose say: concise paragraphs with one idea each, lists only for truly parallel or sequential items, plain words, active voice, main point first. Use OpenAI's slop blocklist: "delve," "foster," "leverage," "it's worth noting," "importantly," "Bottom line:", "In short:", "X, not Y" contrasts, invented hyphenated compounds, vague qualifiers, canned transitions, and stating what it will not do.
- **Delegation.** Delegates less than you may want. If the harness has subagents, say when and how much to parallelize, and that inter-agent messages must be legible with proper spacing.
- **Testing.** Over-tests small changes. Say: no tests for reversible low-impact changes that mirror the implementation; run what the change needs, then broaden only when new failures or unresolved concerns justify it.

*What Codex already tells it.* Codex's bundled instruction template for Astra (`~/.codex/models_cache.json`) carries all five blocks verbatim, plus the approval rule, the skill-naming debug rule, batching rules, and PR-body conventions. In a Codex session, do not repeat them in `AGENTS.md` or a task prompt; a task prompt needs Goal, Context, Output, Boundaries, one autonomy sentence for this task, and the gates by name. Outside Codex (API, ChatGPT, a Grok-hosted or Cursor-hosted call) write the five behaviors into the brief yourself.

*Effort per job.* Override per call (`-c model_reasoning_effort=high` on the Codex CLI): `low` for readbacks and yes/no checks; `medium` for ordinary build or review work; `high` for planning, attacks, self-audits, and strategy calls; `xhigh` or `max` only with evidence.

*Do / Don't.*
- Do: "Read these seven files in order, then return one document with these six sections; read-only; stop after section F." Don't: "Take a look at the playbook and tell me what you think."
- Do: date each rule and say which one wins: "Review discipline (2026-09-09; newer than the line above)." Don't: leave two undated rules that conflict; Astra will pick one and stop, or ask.
- Do: "Reversible work needs no permission; the merge and the deploy are gates and stay shut." Don't: "Ask before doing anything risky."

*Pitfalls.* It refuses to quote hook-injected or system context when asked directly, so verify hook delivery with a behavioral question (a fact only the hook carries). It labels its own implementation work "success" even when a procedure was skipped, so ask for the procedure step table, not the outcome word. It runs `AGENTS.md` pointers on every step; each "read X first" is paid per step. `ultra` exists only on the Codex surface.
