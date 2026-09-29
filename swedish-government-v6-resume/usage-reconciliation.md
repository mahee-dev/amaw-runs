# Run 8 provider-usage reconciliation

**Reconciled:** 2026-09-15  
**Game:** `524ba2d8-aa79-4b91-b11a-93fb37b9494b`  
**Provider interval:** 2026-09-14 21:35:07–2026-09-15 03:38:51 GMT+2

## Result

Run 8 consumed approximately **63.7 million inclusive tokens** (provider prompt/input plus
completion/output). The format-v4 export retained exactly **13,904,633** of them, so approximately
**49.8 million tokens were omitted** by the pre-I-050 failed-activation accounting path. The
exported figure is about **21.8%** of provider-observed workload, not the run total. The same
provider view reports approximately **$2.24 total spend**; the export's `$0.040214385074` covers
only the 32 Umpire rows and is not comparable to the provider-wide spend.

The provider value is rounded to one decimal million. On ordinary display rounding, the inclusive
total lies in `[63.65M, 63.75M)`, and the omitted amount lies in approximately
`[49,745,367, 49,845,367)` tokens. A provider CSV or Analytics API result would be required to
replace this bounded estimate with an exact integer.

## Request reconciliation

| Boundary | Requests | Usage retained by format v4 |
|---|---:|---:|
| Provider HTTP `200` | 1,049 | 779 |
| Provider HTTP `400` | 1 | 0 |
| Model attempts that did not reach provider HTTP | 18 | 0 |
| **AgentRun model attempts** | **1,068** | **779 usage-bearing responses** |

The 779 retained responses comprise 746 successful player requests and 33 Umpire requests. Their
stored inclusive token sum is `11,606,440 input + 2,298,193 output = 13,904,633`.

The 270 successful responses whose usage was lost comprise:

- 192 responses in nine guardrail-ceiling activations;
- 78 responses in deterministic failed activations, including acknowledgement failures and the
  23 successful requests before one final provider `400`;
- no responses from the nine transient failures (18 attempts), because those attempts did not
  reach a logged provider HTTP response.

This is the exact failure shape I-050 now handles: every returned response usage record is retained
across framework rejection, activation failure and logical retry. At the provider estimate, the 270
omitted responses account for approximately 49.8M tokens, or about 184,000 inclusive tokens per
response on average. That high average is consistent with the concentration of omissions in
21/24-request tool loops whose accumulated histories were repeatedly resubmitted; it is an
aggregate consequence, not a reconstructed per-request measurement.

## Cache and topology interpretation

The filtered provider Activity view reports a **50.8% cache-hit rate**, and individual Run 8
generations visibly carry the provider's `Cached` marker. This is evidence that provider-reported
cache use occurred. Cache-read tokens are a subset of prompt/input tokens, so they must not be
added to the 63.7M inclusive total. Reasoning tokens are likewise a subset of completion/output
tokens under I-050 accounting.

The same dashboard screenshot also shows **71.1M tok** in the `Top API Keys` and `Top Apps`
ranking cards while its filtered `Token volume` card shows **63.7M**. The screenshots do not expose
the ranking widgets' query or metric definition, so the 7.4M difference is recorded as an
unresolved dashboard-aggregation discrepancy. It is not added to the inclusive total and must not
be labelled additional Run 8 usage without a detailed export.

Run 8 predates I-056. Consequently, no historical component byte counts, request growth, stable
prefix lengths/digests, per-request cache-read/write counts or tokenizer reconciliation are
available. The existing export and logs do not retain the serialized requests needed to recreate
them. Provider cache hits demonstrate provider-reported cache use only; they do not prove which
AMAW component formed the cached prefix or that I-056 structural overlap caused a hit.

## Evidence and limits

- `export.json`: format-v4 AgentRuns and exact retained token totals.
- `run.log`: 1,050 OpenRouter HTTP completions calls from 21:35:07 through 03:38:51 GMT+2,
  comprising 1,049 `200` responses and one `400`.
- Retained operator-supplied OpenRouter screenshots: AMAW-key filter, approximately 1K requests,
  63.7M token volume, $2.24 spend, 50.8% cache-hit rate, 71.1M ranking-card value, and a cached
  DeepSeek V4 Flash generation. `provider-evidence.md` names and hashes each image.

This reconciliation is provider-backed operational evidence for one playtest. It is not a
fixed-condition comparison, a cache-performance experiment, or a benchmark result.
