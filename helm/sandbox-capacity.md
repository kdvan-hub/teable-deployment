# Sandbox capacity: sizing the memory request

`global.sandboxScheduling.memoryRequest` is the single knob that decides how
many sandboxes fit on a node. It is worth understanding before you set it,
because both directions of getting it wrong produce confusing symptoms that
look like something else.

## What the memory request actually is

It is **not** a prediction of how much memory a sandbox will use, and it is not
a cap — that is `memoryLimit`. It is the **price of a seat**: the Kubernetes
scheduler subtracts it from the node's allocatable memory every time a sandbox
lands, and stops placing sandboxes once the node's requests are booked up.

```
sandbox seats per node  ≈  node allocatable memory / memoryRequest
```

That is the whole model. There is no per-node sandbox count to configure —
capacity is derived, so changing node sizes or the request automatically
changes density without touching anything else.

CPU is deliberately kept out of the equation: `cpuRequest` is set very small
(50m) so that memory stays the single binding constraint. If you raise
`cpuRequest` to a realistic-looking value, CPU becomes the limiting factor on
some node shapes and the density arithmetic above silently stops holding.

## Why not just set it to what a sandbox really uses

Because "what a sandbox really uses" is a distribution, not a number, and the
two ways of collapsing it are both wrong:

- **Set it near the mean → oversubscription.** The scheduler believes the node
  has room it does not have. Real usage climbs past allocatable, the node
  crosses the memory watermark, backpressure taints it against new sandboxes,
  and under genuine pressure the kernel OOM-kills whichever process is largest
  — often somebody's live session. *Symptom: sandboxes die mid-session; nodes
  sit tainted for long stretches; memory alerts on nodes that "should" have
  room.*

- **Set it near the peak → you buy seats you never fill.** One outlier
  workload sets the price for every sandbox. Nodes report low real utilization
  while the cluster refuses to place new sandboxes. *Symptom: sandbox creation
  fails or stays Pending while `kubectl top node` shows plenty of free memory.*

The right number is **a high percentile of observed steady-state usage plus
headroom** — high enough that the typical sandbox comfortably fits, low enough
that a rare heavy one does not tax everyone. Capping the rare heavy one is
`memoryLimit`'s job, not this knob's.

## Recommended starting value

```yaml
global:
  sandboxScheduling:
    memoryRequest: "1300Mi"
    cpuRequest: "50m"
```

1300Mi suits a **mixed workload** — interactive AI sessions plus occasional app
builds — which is what most deployments actually run. It leaves room for a
session to pull in a toolchain without immediately pushing the node past its
watermark.

Worked example on a 32 GiB node (≈30 GiB allocatable after kubelet and system
reservations):

| memoryRequest | seats per node | comment |
| --- | --- | --- |
| 700Mi | ≈ 43 | dense; only safe when sessions are consistently light |
| **1300Mi** | **≈ 23** | recommended starting point for mixed workloads |
| 2Gi | ≈ 15 | build-heavy deployments |
| 3Gi | ≈ 10 | data-processing workloads |

Leaving `memoryRequest` empty keeps the server's built-in default and does not
change existing behavior — that is the chart default, so upgrades never move
your density underneath you. Setting it is an explicit decision.

## When you need a different number

1300Mi is a starting point, not a universal answer. Re-derive it when your
workload profile differs:

| Your workload | Direction | Why |
| --- | --- | --- |
| Mostly short interactive AI sessions, light tooling | Lower — 700–900Mi | Steady-state footprint sits well under 1 GiB; a higher request just wastes seats |
| App builds (production Next.js builds), bundlers, test suites | Higher — 2–3Gi | Build steps are memory-spiky and long enough that the spike *is* the steady state |
| Data processing, notebooks, large in-memory datasets | Higher — measure first | Usage tracks dataset size, not the runtime; no default generalizes |
| Very small nodes (< 8 GiB allocatable) | Reconsider node size | Below roughly 8 seats per node, per-node overhead dominates and the request is not the thing to fix |

## Deriving it for your own cluster

Sample the real distribution during a representative busy period — not
overnight:

```bash
kubectl top pod -n <sandbox-namespace> --no-headers \
  | awk '{print $3}' | sort -h
```

Take the p90–p95 value and round up by roughly 20%. If you retain metrics,
prefer a week of `container_memory_working_set_bytes` over a point-in-time
sample; a single `kubectl top` snapshot misses the daily peak.

Then sanity-check the result against your node size using the table above. If
the number you derived yields fewer than ~8 seats per node, the node shape is
the problem, not the request.

## Changing it later

The change is hot-swappable and applies to **newly created** sandboxes only.
Existing sandboxes keep the request they were created with until they cycle
through a pause/resume, so density shifts gradually rather than all at once.
Plan to observe over a day rather than expecting an immediate change.

If you run balloon pods (`sandboxScheduling.headroom.replicas` > 0), their
requests follow `memoryRequest` automatically unless you overrode
`headroom.requests` explicitly — in that case update both together, or a
balloon will stop holding exactly one sandbox slot.

## Related knobs

- **`memoryLimit`** — the per-sandbox circuit breaker, not the density knob.
  Note that a sandbox create request carrying explicit resource limits replaces
  the template values, so `memoryLimit` currently acts as a fallback for
  clients that omit them rather than as a hard ceiling.

- **`backpressure`** (default on) — the safety valve that catches a
  too-low request: it taints a node `NoSchedule` at 90% node memory and
  releases it at 80%. It is a backstop, not a substitute for sizing the request
  correctly. **It only acts on nodes matching
  `backpressure.nodeSelector` (default `teable.io/node-pool=sandbox`)** — if
  your sandbox nodes carry a different label, backpressure silently does
  nothing and an undersized request has no safety net. Check this first if you
  see OOM kills but never see a tainted node. It also needs metrics-server and
  the node-patch RBAC (rendered when `infraService.rbac.clusterScope.create` is
  true).

- **`packing.enabled`** (default on) — bin-packing affinity: sandboxes prefer
  the fullest node rather than spreading evenly, so fewer, fuller nodes run and
  empty nodes can be reclaimed. It changes placement distribution, not density.
