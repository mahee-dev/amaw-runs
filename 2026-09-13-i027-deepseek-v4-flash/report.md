# I-027 — DeepSeek v4 Flash throughput measurement

**Date:** 2026-09-13
**Scenario:** `svensk-regeringsbildning-2026` v4
**Seed:** `20260913`
**Player/Umpire model:** `deepseek/deepseek-v4-flash-0731`
**Umpire prompt:** `umpire-v1.3`
**Cons concurrency:** `4`
**Code version:** `70a14c4cb26f42f16c18586ac05cab9f91468456`

The existing T-053 instrumentation was used through `uv run amaw run`. No production code,
SQLite, FastAPI or HTTP implementation was changed.

## Results

| Condition | Game state at stop | Completed activations | Persisted model calls | Input tokens | Output tokens | Tool calls | Provider wait | Cost |
|---|---|---:|---:|---:|---:|---:|---:|---|
| `single_shot` | turn 1, diplomacy | 8 | 34 | 354,866 | 89,933 | 86 | 1,562,984 ms (26m 03s) | unavailable |
| `tool_loop` | turn 1, diplomacy | 0 | 0 | unavailable | unavailable | unavailable | unavailable | unavailable |

The `single_shot` records are the eight completed initial diplomacy activations, one per Actor.
They also persisted 51 Messages and 75 Resource accesses; no Argument, Con or Umpire activation
was reached. The raw log contained 62 provider HTTP requests by the time the run was stopped,
including calls belonging to an unfinished follow-up activation; the T-053 aggregate above uses
only the eight completed append-only `AgentRun` rows. Activation wall time was 1,563,494 ms.

The `tool_loop` comparison made 4 provider requests and 6 Resource accesses in the first Actor
activation, but no activation completed and no AgentRun row was written. It was stopped after the
provider returned HTTP 200 while producing no further persisted progress. The coordinator did not
complete its first sweep, so `--max-cycles 1` was not reached.

OpenRouter did not return usable cost values for these calls, so the cost field is honestly
`unavailable`; no cost estimate is fabricated. The evidence shows the bottleneck is provider/model
wait and model-loop activity during diplomacy, not local server work. It does not support claims
about downstream Argument, Cons or Umpire proportions because neither condition reached those
phases. The raw temporary artifacts were captured under `/private/tmp/amaw-i027-deepseek-single-shot`
and `/private/tmp/amaw-i027-deepseek-tool-loop`; credentials were not copied into this report.
