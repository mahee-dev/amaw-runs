# Run 8 provider evidence manifest

**Captured:** 2026-09-15  
**Source:** Operator-supplied OpenRouter Activity/Generations screenshots  
**Scope:** AMAW API key, DeepSeek V4 Flash 0731, Run 8 time window

The screenshots are retained as provider-side operational evidence. They contain generation
metadata and a truncated API-key identifier, but no prompt text, completion text, bearer token or
reasoning content.

| File | Evidence | SHA-256 |
|---|---|---|
| `openrouter-activity-overview.png` | AMAW-key filter; approximately 1K requests; 63.7M Token volume; $2.24 spend; 50.8% cache-hit rate; conflicting 71.1M ranking-card value | `ba2681737abf355385c1c270d5e82ab3c6720d3b332cba96592ee0302594fd92` |
| `openrouter-generations.png` | DeepSeek V4 Flash generation rows in the provider time range, including input/output token counts, provider, cost and cache markers | `bbee6723d5a26689456c8234d9f3bc4fdecf42e8c896c6801f9723bc47dbbcc4` |
| `openrouter-cached-generation.png` | One cached generation detail: 20,595 input, 2,426 output, StreamLake, provider HTTP 200 and $0.000715 cost | `6012bee721c6a426fcda44ae24f6f63d784e28f5f99eecb658f34c7a3cfbcd89` |

These images support the rounded aggregate reconciliation in `usage-reconciliation.md`. They do
not provide an exact CSV total, per-request export, or historical I-056 topology. The 63.7M and
71.1M dashboard values must therefore remain distinct rather than being combined or silently
resolved.
