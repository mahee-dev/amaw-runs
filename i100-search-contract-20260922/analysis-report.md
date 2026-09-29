# I-100 provider comparison — released `search-v1` versus candidate `search-v2`

**Completed:** 2026-09-23 01:27 UTC
**Scenario:** `northern-strait` v1
**Decision:** **A — adopt `search-v2` for the future released default, in a separate follow-up change.** The current default remains `search-v1` until that change is made. `search-v1` remains supported and selectable.

## Design and provenance

This was the predeclared four-game paired experiment in
`dev/plans/2026-09-22-i100-search-contract-comparison.yaml`:

- analysis-plan hash: `2a66423c6d25efbea0f27589fb8387da461ebcdf34ba7d70a2089f389a8ba613`;
- only treatment factor: sealed `search_contract`, with `search-v1` and `search-v2`;
- exact paired seeds: `60000` and `60001`, each used once per contract;
- predeclared block order: `search-v2` seed 60000, `search-v2` seed 60001, then
  `search-v1` seed 60000 and `search-v1` seed 60001;
- same Northern Strait scenario/resource hashes, player and Umpire model, prompts, tool
  surface, research topology, budgets, guardrails, concurrency, timeout and scheduling seed;
- model: `deepseek/deepseek-v4-flash-0731` in all three Seats and as Umpire; `tool_loop`,
  broad tools, `sequential-v1`, `full-v1`, player-v1.10, Umpire-v1.3, PydanticAI 2.42.0;
- all four attempts completed six turns; no replacement or post-hoc extension was made.

The first one-game CLI preflight was rejected before any provider call because the plan's
`planned_attempts: 4` did not match the temporary one-game schedule. The plan was corrected to
the declared two repetitions per treatment, revalidated, and the four-game run then proceeded.

## Paired retrieval results

Rates use the I-099 `app.summary.build_resource_research_report` totals. “Returned-read” is
`search_returned_read_conversions / searches`; the sequence-only `search_to_read_conversions`
metric is reported separately.

| Seed | Contract | Searches | Zero-result (rate) | Identical-set reformulations (rate) | Returned-read conversions (rate) | Sequence search→read | Reads |
|---:|---|---:|---:|---:|---:|---:|---:|
| 60000 | v1 | 51 | 43 (84.31%) | 23 (45.10%) | 1 (1.96%) | 1 | 1 |
| 60000 | v2 | 27 | 1 (3.70%) | 6 (22.22%) | 17 (62.96%) | 13 | 17 |
| 60001 | v1 | 58 | 54 (93.10%) | 32 (55.17%) | 0 (0.00%) | 0 | 0 |
| 60001 | v2 | 29 | 1 (3.45%) | 7 (24.14%) | 16 (55.17%) | 12 | 16 |

| Aggregate | Searches | Zero-result (rate) | Reformulations (rate) | Returned-read conversions (rate) | Sequence search→read |
|---|---:|---:|---:|---:|---:|
| v1 | 109 | 97 (88.99%) | 55 (50.46%) | 1 (0.92%) | 1 (0.92%) |
| v2 | 56 | 2 (3.57%) | 13 (23.21%) | 33 (58.93%) | 25 (44.64%) |
| v2 − v1 | −53 | −85.42 percentage points | −27.24 percentage points | +58.01 percentage points | +43.73 percentage points |

Every search row in all four exports has result metadata (`searches_without_result_metadata = 0`);
there are no unattributed Resource accesses. v1 read one Resource (`background`) once. v2 read
all 33 returned Resources, covering the three public scenario Resources (`arkania-intel`,
`background`, `trade`).

## Behaviour, efficiency and failures

All four games completed with six turns, 36 Arguments and 36 adjudications in total. Aggregate
play telemetry was:

| Measure | v1 | v2 | v2 − v1 |
|---|---:|---:|---:|
| Arguments | 36 | 36 | 0 |
| Cons | 40 | 31 | −9 |
| Effects | 116 | 97 | −19 |
| Messages | 84 | 75 | −9 |
| Events | 616 | 590 | −26 |
| Player model calls | 745 | 678 | −67 |
| Umpire calls | 38 | 39 | +1 |
| Input tokens | 6,745,247 | 5,559,546 | −1,185,701 |
| Output tokens | 838,203 | 708,877 | −129,326 |

The candidate used fewer player calls and tokens while producing the same number of Arguments,
turns and adjudications. Cons, Effects, Messages and Events shifted descriptively; this is
behavioural drift worth monitoring, not a failure or a change to engine legality. Aggregate
activation wall/provider-wait time was lower for v2 (16,979,840/16,968,720 ms versus
18,693,103/18,682,801 ms), but elapsed game runtime was noisy and higher for v2 because seed
60000 took an unusually long provider path. This experiment therefore makes no latency claim.

Partial provider-cost telemetry was nearly equal: v1 `$0.0844611384` versus v2 `$0.081247610168`.
Coverage was incomplete in every export (v1 38 of 783 model calls with cost; v2 38 of 717), so
these are provider-reported partial estimates, not a billing conclusion. v1 recorded 6 failed
player activations, 2 failed Umpire attempts and 8 `agent_errors`; v2 recorded 1, 3 and 4. All
four batch attempts completed and all provider/Umpire/activation faults were retained in the
exports; none caused a failed game. Invalid tool-call telemetry was 64 for v1 and 75 for v2,
consistent with the intentionally broad `tool_loop` condition.

## Integrity checks

- Both `batch.json` files report `integrity.ok`, `attempts_as_scheduled`, `condition_fixed`,
  `umpire_fixed`, and no failures.
- Each contract contains exactly one completed attempt for each paired seed; the timestamped
  batches confirm the declared v2-then-v1 block order.
- The plan hash, environment hash (`61c484f1d4cbf5f2165d0dea6b90fa787bca8ce0577583e2e2c7274f5dd83480`),
  scenario content hash (`5374227996e7eca25bde6fb3fa69824c04b886ce7b2709ac57dd8ca0454f85e2`),
  resource-manifest hash (`cb6fd6b9a30e2414130f02f306c53506e5762c21620fbf808b1e8cc92a723059`),
  player prompt/tool identities, and Umpire condition hash
  (`1ca4c08a0684cfb1ff0a852bdc901ae1e228559c447e3edaaa3e17111d6de79e`) match across arms.
- The only intended condition difference is manifest/AgentRun `player.search_contract`: v1 or
  v2. The two blocks used separate databases and output trees, so replay/cache state did not
  cross treatments.
- The raw exports retain game state, AgentRuns, ResourceAccess rows, provider usage, failure
  reasons, manifests, attempt records and CSV projections. The I-099 report function was run
  against each completed game database; the totals above are its output.

## Evidence and interpretation

Raw v1 evidence is in `dev/runs/i100-search-contract-20260922-v1/i100-search-v1/`; raw v2
evidence is in `dev/runs/i100-search-contract-20260922-v2/i100-search-v2/`. This report is the
analysis record for the four retained attempts. With only two paired seeds, the result is
descriptive rather than a significance test or a causal estimate. Nevertheless, v2 wins all
three predeclared retrieval outcomes by a large margin, reduces wasted search activity and
does not prevent completion or change the Argument/adjudication count. That satisfies the
predeclared Decision-A rule. A separate follow-up must change the released default after adding
the corresponding default/manifest regression evidence; this task does not make that source
change.
