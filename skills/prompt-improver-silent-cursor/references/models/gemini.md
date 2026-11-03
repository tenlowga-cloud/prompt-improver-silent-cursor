---
family: Gemini text (Google)
verified: 2026-09-03
---
# Prompting card — Gemini (text)

Sources fetched 2026-09-03: ai.google.dev prompting strategies, models list, Gemini 3 developer guide. Bracketed numbers point to those source pages. In Cursor (2026-11-03) the Gemini models on offer are Gemini 4 Argon, Gemini 3.1 Pro and the Gemini 3.x Flash family; Gemini 4 Argon is newer than this card, so start from the Gemini 3 rules and re-check ai.google.dev.

**1. Models and when to use which**

| Model | ID | Use for |
|---|---|---|
| Gemini 3.1 Pro (preview) | `gemini-3.1-pro-preview` | Complex reasoning, broad world knowledge, vibe coding [3] |
| Gemini 3 Flash (preview) | `gemini-3-flash-preview` | Pro-level intelligence at Flash speed and price; general agentic work [3] |
| Gemini 3.1 Flash-Lite | `gemini-3.1-flash-lite` | Cheapest, highest-throughput text tasks [4] |

Model IDs churn fast; re-check `ai.google.dev/gemini-api/docs/models` before hard-coding one.

**2. What is different about Gemini text models**
- Gemini 3 has built-in thinking; do not ask it to show chain-of-thought, that mostly wastes tokens [4][7].
- `thinking_level`: `minimal | low | medium | high`, default `high`. Drop to `low` for latency-sensitive simple tasks [7].
- Temperature: keep at the default **1.0**. Lowering it can cause looping or degraded reasoning on complex tasks, the opposite of older-model advice [7].
- Terser by default than earlier models; ask explicitly for a conversational tone if you want one [4][7].
- `media_resolution` (`low / medium / high / ultra_high`) controls vision-token spend per image or frame; PDFs saturate at `medium`, images want `high` [7].
- `thoughtSignature` carries reasoning state across turns; required for function calling and image-edit continuity or the API returns 400 [7].
- Structured output (JSON schema) now combines with built-in tools (Search, URL context, code execution, function calling) [7].
- Enable Search grounding for current or obscure facts; enable code execution for arithmetic and counting [3].

**3. Prompt skeleton that works**
- Use consistent delimiters: XML tags (`<role>`, `<context>`, `<task>`, `<constraints>`) or Markdown headings, one format per prompt [3].
- Long context: reference material first, the actual question **last**, bridged with "Based on the information above..." [3][7].
- Few-shot examples are recommended by default; Google says prompts without them are "likely to be less effective." Keep example formatting perfectly consistent [3].
- Google's Gemini 3 template:
```
<role>You are Gemini 3, a specialized assistant for [Domain]. You are precise, analytical, and persistent.</role>
<instructions>1. Plan  2. Execute  3. Validate  4. Format</instructions>
<constraints>Verbosity: [Low/Medium/High]  Tone: [Formal/Casual/Technical]</constraints>
<output_format>1. Executive Summary  2. Detailed Response</output_format>
```
then the user prompt is `<context>...</context><task>...</task><final_instruction>Remember to think step-by-step before answering.</final_instruction>` [3].

**4. Controls that shape output**
`thinking_level`, `temperature` (leave at 1.0), `media_resolution`, `response_format` / JSON schema (combinable with tools), `thoughtSignature` (echo back verbatim), `tools: [google_search, url_context, code_execution, function_declarations]` [3][7]. `candidateCount > 1` is rejected (400) on Gemini 3 [7].

**5. Do / Don't**
- Do give few-shot examples in one consistent format. Don't mix example formats or skip examples on a shaped task.
- Do put the question after the context. Don't bury it above a long document.
- Do echo `thoughtSignature` on every follow-up in a tool or edit chain. Don't drop it; that is a hard failure, not a quality loss.
- Do ask for the tone you want. Don't assume the default is conversational.

**6. Pitfalls**
- Asking for visible chain-of-thought on a thinking model wastes tokens.
- Temperature below 1.0 can loop on Gemini 3.
- Dropping `thoughtSignature` breaks function-calling and image-edit continuity.
