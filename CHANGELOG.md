# Changelog

User-visible changes, grouped by platform release (component pins for each
release live in [`VERSIONS.md`](VERSIONS.md)). Each entry says what changed
and what you must do — most entries need no action.

"Teable `release.*`" sections record the app releases picked up by the stable
channel, with their release notes synced in. Docker installs follow `latest`
directly; Kubernetes installs receive the refreshed pin via that platform
release's `versions.yaml`. Hot-swappable; no action needed.

## v2026.8.6 - 2026-08-05

### Teable release.2026-08-05T08-59-48Z.2496

`ghcr.io/teableio/teable:latest` now resolves to `release.2026-08-05T08-59-48Z.2496`.

[Full release notes](https://github.com/teableio/teable/releases/tag/release.2026-08-05T08-59-48Z.2496)

## v2026.8.5 - 2026-08-05

### Teable release.2026-08-05T06-42-00Z.2495

`ghcr.io/teableio/teable:latest` now resolves to `release.2026-08-05T06-42-00Z.2495`.

## v2026.8.4 - 2026-08-05

- **Sandbox engine `v0.2.0-fix9` accepts setgid `dir_mode`.** Values above
  `0o777` (e.g. `0o2775`) in `[kubernetes.volume_subpath_precreate]` no longer
  fail server startup validation; pairs with the new Helm README recipe for
  sandbox volumes owned by a different identity than the sandbox user.

## v2026.8.3 - 2026-08-03

- **Infra Service now always watches the sandbox and app-deploy namespaces.**
  The `K8S_NAMESPACES` list automatically includes `sandboxNamespace.name` and
  (when app deployment is enabled) `appRuntime.namespace`, fixing default
  installs where active sandboxes in `teable-sandbox` were invisible to the
  Infra Service ([teable-deployment#1](https://github.com/teableio/teable-deployment/issues/1)).
  If you had manually added these to `infraService.namespaces`, you can remove
  them; otherwise no action needed.

## v2026.8.2 - 2026-08-02

- **App switcher targets are now configurable.** The v2026.8.1 boolean
  `infraService.internalAppSwitcher` is replaced by
  `infraService.internalAppSwitcherApps` — a list of `{name, desc, url,
  current}` entries pointing at your own companion control planes. Empty
  (default) hides the switcher. If you had enabled the boolean, move your
  targets into the list; otherwise no action needed.

## v2026.8.1 - 2026-08-02

- **Optional operator app switcher in the Infra Service sidebar.** New value
  `infraService.internalAppSwitcher` (default `false`) shows a grid button
  linking to companion control planes, for operators running several of them.
  When left off the UI is unchanged. No action needed.

## v2026.8.0 - 2026-08-01

- **The sandbox engine can run under a chosen identity.** New
  `opensandbox-server.server.podSecurityContext` / `securityContext` /
  `containerPort` values. Useful when a shared sandbox volume is owned by a
  uid other than the default: run the engine as that uid and its subPath
  pre-creation writes directories directly, with no chown. Non-root also needs
  `containerPort` (and `[server] port` in `configToml`) moved off port 80.

## v2026.7.28 - 2026-07-30

- **Docker server mode: storage API calls no longer fail with an empty `S3Error`.**
  The entry routed `/<bucket>/...` to MinIO but not the bare `/<bucket>` path that
  S3 clients send as `GET /<bucket>?location`, so those requests got console HTML
  and some app endpoints returned 500; `doctor.sh` now probes the bare path too.
  Existing installs: pull the updated Caddyfiles, then run
  `docker compose up -d --force-recreate caddy`.
- **Docker mode: a new user's first sandbox no longer crashes with a
  permission error.** When a sandbox workspace directory did not exist yet,
  Docker created it owned by root, and the sandbox (running as uid 1000)
  failed on first write. The sandbox engine (`v0.2.0-fix8`) now pre-creates
  these directories with the sandbox user's ownership. Existing Docker
  installs: set `OPENSANDBOX_SERVER_IMAGE` to `ghcr.io/teableio/opensandbox-server:v0.2.0-fix8`
  in your `.env`, then re-run `apply.sh`. Kubernetes installs are not
  affected.

### Teable release.2026-07-30T06-45-38Z.2429

#### Feature Updates
- Added mobile-friendly controls to shared pages, making key options such as sign-in easier to access on small screens.
- Custom emoji icons can now be removed from tables and Bases to restore the default icons.
- Added a CLI-based permission matrix configuration workflow for exporting, editing, previewing, comparing, and applying declarative permission settings, with validation and safeguards against accidental lockouts.

#### Bug Fixes & Improvements
- Improved initial table loading performance and prevented blank rows by ensuring consistent initial record data across different loading paths.
- Rerunning an automation workflow now keeps you in the current tab and task context.
- Improved stability and responsiveness when clearing large numbers of cells.
- Added consistent loading states when opening, refreshing, or switching between tables, automations, apps, dashboards, and other Base content.
- Fixed an issue where Grid views with many visible fields remained stuck on loading placeholders after scrolling beyond the first 100 records.
- Selecting content while Chat is expanded on desktop now restores the side panel layout without losing the conversation, draft, attachments, or scroll position. The expanded layout remains unchanged when interacting with folders.
- Reduced initial loading delays when opening a Base from a space, while accommodating data-saving mode and extremely slow network connections.
- Question cards and confirmation cards now appear faster with more streamlined options, handle unanswered prompts more effectively, and avoid unnecessary spacing or layout shifts.
- Newly created AI Chat and App Builder sandboxes now always use the latest CPU, memory, and temporary disk limits configured in System Administration.
- Fixed an issue where select values temporarily disappeared after converting a field between single select and multiple select.
- Improved grouped Grid views so that expanding or collapsing groups updates only the affected area, preserves scroll context, and maintains accurate layouts after view changes.
- Improved stability for Bases with many calculated fields and conditional summaries, reducing redundant calculations and resource pressure during frequent updates.
- Fixed incorrect variable selection in automation condition nodes following scheduled triggers.
- Improved AI Chat completion response speed and failure recovery.

[Full release notes](https://github.com/teableio/teable/releases/tag/release.2026-07-30T06-45-38Z.2429)

## v2026.7.27 - 2026-07-30

- **The Teable app now trusts your private CA.** With `infraService.privateCa`
  enabled, the CA bundle now also mounts into the Teable app pod -- sandbox
  creation and app deploys no longer fail TLS verification on a private PKI.
  Already using the switch? `helm upgrade` is enough (Teable deployed outside
  this chart: see `helm/private-ca.md`).

## v2026.7.26 - 2026-07-30

- **Upgrades that skip releases can now compute their pending migrations.**
  `versions.yaml` gains `migrationCatalog` -- every migration this release
  line has ever required, with the release that introduced it -- rendered as
  "Upgrading across releases" in `VERSIONS.md`; `doctor.sh --from
  <your-release>` (Docker and Helm) prints what your install still has to
  run. No action needed.

## v2026.7.25 - 2026-07-29

- **`VERSIONS.md`: the sandbox-chain verification reads as its own line.** It
  rendered nested under the Kubernetes entry, which made it look like part of
  that run rather than a separate check. No action needed.

## v2026.7.24 - 2026-07-28

- **Reserve kubelet memory on dedicated sandbox nodes — action needed.**
  Bin-packing (`sandboxScheduling.packing`, default since v2026.7.15) fills
  sandbox nodes to their allocatable limit, so a node left on its provisioner's
  default reservation can lose its kubelet under load and drop every sandbox on
  it. Set `system-reserved`/`kube-reserved`/`eviction-hard` in your node
  provisioner, then replace existing sandbox nodes — the reservation applies at
  node bootstrap only.
- **`VERSIONS.md` now dates the sandbox-chain verification separately.** The
  Docker/Kubernetes dates cover the full journey; a release that only moves the
  sandbox engine or execd now carries its own, current date for that chain
  instead of implying the whole journey was redone. No action needed.

## v2026.7.23 - 2026-07-28

- **Sandboxes can run unprivileged.** `global.sandboxSecurity.nonRoot.enabled=true`
  runs new sandboxes as uid 1000 with all capabilities dropped, and
  `seccompProfile: RuntimeDefault` hardens the profile. Both off by default;
  read "Hardening sandboxes" in `helm/README.md` before enabling.
- **Sandbox engine `v0.2.0-fix7`, execd `v1.0.19-fix3`** (required by the
  switch above). Helm installs get them from `versions.yaml`; Docker installs
  on the next `apply.sh`.

## v2026.7.22 - 2026-07-28

- **New guide for sizing sandbox capacity.** `global.sandboxScheduling.memoryRequest`
  decides how many sandboxes fit on a node, and both a too-low and a too-high
  value fail in confusing ways. Start at `1300Mi` for a mixed AI-session and
  app-build workload (roughly 21 sandboxes on a 32 GiB node), then re-derive it
  from your own usage. The guide also covers the kubelet memory reservation
  bin-packing needs -- without it a full node can starve its own kubelet while
  the cloud console still reports the instance healthy. See
  `helm/sandbox-capacity.md`; if bin-packing is already on, check your node
  reservation against it.

## v2026.7.21 - 2026-07-28

- **Private CA trust for sandboxes is now a values switch.** Set
  `global.sandboxPrivateCa.enabled=true` and point `configMapName` at a
  ConfigMap holding a full CA bundle (public roots plus your corporate root);
  new sandboxes then trust it system-wide instead of in Node only. If you
  hand-edited `batchSandboxTemplate` for a private CA, move to the switch and
  drop those lines -- see `helm/private-ca.md`.

## v2026.7.20 - 2026-07-27

- **A failed app update no longer takes down the running version, and sleeping
  apps are no longer removed.** App Runtime keeps the previous version serving
  while a new version fails to become ready, and apps scaled to zero are never
  treated as unhealthy leftovers. Re-publish a failed update to retry; no other
  action needed.

## v2026.7.19 - 2026-07-27

### Teable release.2026-07-27T10-51-13Z.2393

#### Feature Updates

- Reorganized navigation on the system administration page into clearer groups.
- Expanded audit logs: delete operations now include specific record IDs, each log includes the API endpoint that generated it, and space and base creation, deletion, and modification are also recorded.
- Unified collaborator invitation notifications across email and in-product channels, with toast notifications for unread invitations.
- Strengthened sandbox permission controls. Agents can still install user-space dependencies, while required system packages must be preinstalled.

#### Bug Fixes & Improvements

- Improved enterprise SSO reliability for generated applications. Authorization failures now display clear errors instead of loading indefinitely.
- Improved automation reliability for external databases.
- Improved audit log reliability without interrupting completed user requests.
- Updated the favicon in light mode to improve its visibility and recognizability in browser tabs.
- Improved AI proxy error responses when a base is missing or a token is invalid.

[Full release notes](https://github.com/teableio/teable/releases/tag/release.2026-07-27T10-51-13Z.2393)

## v2026.7.18 - 2026-07-27

- **Sandbox egress fence: allow-list private platform endpoints.**
  `opensandbox-server.server.sandboxNetworkPolicy.additionalAllowedCidrs`
  (`server.…` standalone) keeps private platform VIPs reachable while private
  ranges stay blocked. No action needed unless you enable the fence.
- **Enabling the sandbox egress fence removes the built-in allow-all policy.**
  On existing clusters also delete it once: `kubectl -n <sandbox namespace>
  delete networkpolicy teable-sandbox-allow-all-egress` (apply does not prune).
- **`runtimeNetworkPolicy.*.enabled: false` now actually disables the policy.**
  An explicit `false` used to be treated as unset, so the allow-all kept
  rendering. No action needed.

### Teable release.2026-07-27T06-04-51Z.2385

#### Feature Updates
- Added an organization setting that lets admins enable department keyword search across the entire organization while keeping department tree browsing limited to related departments. The option is off by default and treats wildcard characters literally.
- Renamed the chat entry to “Chat in IM” and updated related terminology to use “IM bot.”

#### Bug Fixes & Improvements
- Cleaned up read-only template previews by removing irrelevant computing status and preventing unnecessary activity checks that could cause 403 errors.
- Restored reliable sorting, filtering, and search for records with missing created or modified metadata.
- Limited field change warnings for button fields to updates that may affect calculations or rewrite data, avoiding warnings for display-only changes such as button text.
- Fixed grouped table views with footer aggregations failing to load for permission-restricted users when the grouping field was hidden.
- Improved sandbox generation reliability by preventing abandoned runs and secondary notification failures from causing repeated retries, cross-run interference, or loss of final results.

[Full release notes](https://github.com/teableio/teable/releases/tag/release.2026-07-27T06-04-51Z.2385)

## v2026.7.17 - 2026-07-27

- **Private CA trust for published apps.** New `infraService.privateCa` values
  mount your corporate CA bundle into the Infra Service and published apps.
  Private-PKI installs: follow `helm/private-ca.md`, then republish apps.
- **Console: the Git Repos page no longer blocks on repository-size scans.**
  The repo listing recomputes per-repo sizes with a full directory scan that can
  take tens of seconds on networked storage; once its 5-minute cache expired the
  next page load paid the whole scan. The listing now serves the previous stats
  immediately and rescans in the background, and the git-registry pre-warms the
  cache on startup, so page loads stay fast right after a deploy too. Sizes may
  be up to one scan-cycle stale. No action needed.
- **Console: one unhealthy node no longer stalls the Sandboxes/Cluster pages.**
  Cluster status collected per-node PVC usage through the kubelet
  `stats/summary` proxy with no dedicated timeout; when a node's kubelet
  stopped serving (e.g. under memory pressure) every page load waited ~11s for
  the apiserver-side TLS handshake to fail. That call now times out after 3s
  and degrades to "no PVC usage data" for the affected node. No action needed.
- **Console: node names now display correctly on EKS/Karpenter clusters.** The
  Sandboxes and Cluster pages rendered nodes as `- · 2.compute.internal` because
  the node pool and display name were still derived from GKE conventions. The
  node pool is now resolved from `teable.io/node-pool`, then
  `karpenter.sh/nodepool`, then `eks.amazonaws.com/nodegroup` (the GKE label is
  still recognized), and `ip-…compute.internal` hostnames keep their host
  segment, e.g. `sandbox · ip-172-31-40-231`. No action needed.
- **Console: the Git Repos page has been reworked.** It now opens with summary
  cards (repo count, total size, repos pushed in the last 7 days, empty repos)
  above a sortable, paginated repository table. Clicking a row slides out a
  panel with the commit history, per-commit diffs and the file browser, and
  every repo has a **Download zip** button that fetches the latest code archive
  (HEAD) using your console session. Search, sort, page and the selected repo
  persist in the URL. No action needed.
- **Console: sandbox table sorting sticks, and Usage is split into CPU / Mem
  columns.** Sorting on the Sandboxes page is now kept in the URL, so a refresh
  (or a shared link) preserves it, and CPU and memory usage sort independently.
  No action needed.
- **Console: the Packages page has been removed.** The package-registry browser
  (internal registry / GCP Artifact Registry / local Docker images) saw no real
  usage and has been dropped, along with its `infraService.packages.*` Helm
  values and `PACKAGE_*` environment variables. Any leftover `packages:` block
  in your values file is now ignored and can be deleted. No action needed.

## v2026.7.16 - 2026-07-26

- **Helm: ingresses accept additional hostnames (`ingress.additionalHosts`).**
  infra-service, git-registry, the sandbox lifecycle API (`/v1`) and the sandbox
  preview gateway can now serve extra hostnames alongside the primary one, using
  the same TLS secret (issue a multi-SAN certificate listing every name in
  `certificate.dnsNames`). Useful for serving a permanent cluster-scoped domain
  next to the public domain during migrations. Empty by default. No action needed.

## v2026.7.15 - 2026-07-26

- **Helm: sandbox egress NetworkPolicy now follows `sandboxNamespace.name`.**
  Previously `runtimeNetworkPolicy.sandbox` had an independent namespace default,
  so renaming the sandbox namespace left the policy pointing at the old (deleted)
  namespace and the upgrade failed. Explicit `runtimeNetworkPolicy.sandbox.namespace`
  values still win. No action needed.

- **Helm: sandbox bin-packing scheduling (`global.sandboxScheduling.packing`).**
  New sandboxes now prefer the fullest node instead of spreading across nodes,
  so clusters run fewer, fuller nodes. Placement-only change for newly created
  sandboxes; set `packing.enabled: false` to keep the old spread. No action needed.
- **Helm: central sandbox scheduling requests (`global.sandboxScheduling.memoryRequest` / `cpuRequest`).**
  Sets the per-sandbox scheduling requests in one place; per-node sandbox
  capacity then derives from allocatable memory. Unset by default (existing
  behavior preserved). No action needed.
- **Helm: warm-capacity balloon pods (`global.sandboxScheduling.headroom.replicas`).**
  Low-priority placeholder pods pre-hold sandbox slots so a new sandbox starts
  instantly while node provisioning happens in the background. Balloons are
  sized from `sandboxScheduling.memoryRequest`/`cpuRequest` (one balloon = one
  sandbox slot) and deploy into the sandbox namespace (`sandboxNamespace.name`).
  Default 0; enable only together with a cluster autoscaler. Air-gapped
  installs must mirror the pause image (`headroom.image`) first. No action needed.
- **Helm: node memory backpressure (`global.sandboxScheduling.backpressure`).**
  infra-service now cordons dedicated sandbox nodes (NoSchedule taint) at 90%
  node memory and uncordons at 80%. It acts only on nodes labeled
  `teable.io/node-pool=sandbox`, so clusters without that label are unaffected;
  requires metrics-server and the node patch grant included when
  `infraService.rbac.clusterScope.create` is true. An optional
  `global.sandboxScheduling.memoryLimit` adds a default per-sandbox memory cap
  (unset by default). Set `backpressure.enabled: false` to opt out — leftover
  backpressure taints are swept automatically on the next service start. Make
  sure sandbox pod tolerations do not use a blanket `operator: Exists`, which
  would defeat the backpressure taint. No action needed.
- **Measured effect of the scheduling changes (our fleet, 4-core/32 GiB dedicated sandbox nodes).**
  Per-node sandbox capacity is now derived from allocatable memory — 42 sandboxes
  per node at the 700 Mi `memoryRequest` we run — instead of being silently capped
  by CPU requests. Nodes fill up before a new one is added, and a drained node is
  reclaimed within minutes (6.5 min measured round-trip), where previously every
  load peak left one extra node running permanently. Net for us: the steady-state
  sandbox pool went from two always-on nodes to one — roughly half the sandbox
  compute cost — with unchanged sandbox performance. Your numbers depend on node
  size and `memoryRequest`; treat these as a reference point. No action needed.

## v2026.7.14 - 2026-07-26

### Teable release.2026-07-26T01-04-56Z.2377

#### Feature Updates

- Added admin-configurable AI concurrency limits for each space, with a default of five concurrent tasks. Additional AI requests are queued and processed fairly across field generation, automations, and other AI workflows.
- Admins with the required permissions can now initiate a password reset for a specific user. Reset links are single-use, expire at the stated time, and are emailed automatically when SMTP is configured. This action is unavailable when password login is disabled.
- Column reordering in grid views now updates immediately without reloading records. Failed saves safely restore the previous order and display an error.

#### Bug Fixes & Improvements

- Fixed lookup values remaining empty or stale after linked source data changed, including filtered records and conditional lookups. Related values now recalculate and synchronize more reliably, with improved performance for large updates.
- Fixed Claw bot chats becoming stuck or losing replies after the bot was removed from the conversation’s Base. Existing chats are moved to another accessible Base where possible, and completed replies are delivered more reliably.
- Improved AI task scheduling, cancellation, recovery, and progress accuracy, including when Bases are deleted or generation tasks stall.
- Improved navigation from Spaces with faster Base entry and continuous loading feedback for pinned Bases, tables, views, dashboards, workflows, and apps. Repeated clicks no longer restart navigation, entry can be canceled, and native new-tab actions remain supported.
- Fixed expired SSO callbacks showing a raw error after browser navigation. Users are now redirected to the app when already signed in or to the login page when authentication is required.
- Improved view switching so rows, sorting, filters, grouping, controls, and permissions from the previous view no longer appear briefly. Recently used views also restore their initial layout more smoothly while fresh data loads.
- Improved credit billing performance and resilience under high-volume activity. Fixed incorrect overlimit blocks after refunds or delayed charges, and improved charge and refund attribution across billing periods and add-on validity windows.
- Fixed BYODB table switching failures caused by schema handling, reducing unclear errors when changing tables.

[Full release notes](https://github.com/teableio/teable/releases/tag/release.2026-07-26T01-04-56Z.2377)

## v2026.7.13 - 2026-07-23

### Teable release.2026-07-23T12-32-52Z.2361

#### Feature Updates
- Added in-app notifications for Space and Base invitations, with direct links to the relevant destination and improved notification accuracy.
- Updated the welcome video on the new base page with the latest onboarding guidance.

#### Bug Fixes & Improvements
- Improved table navigation reliability by automatically opening the last-used or default view and preventing loading screens from becoming stuck when switching tables.
- Improved computed-field responsiveness and reliability, particularly for lookups, linked records, repointing, and large fanout updates under concurrent load.
- Updated CN in-app subscription pricing to match the CN website: ¥70 per seat/month for Professional and ¥140 per seat/month for Business.

[Full release notes](https://github.com/teableio/teable/releases/tag/release.2026-07-23T12-32-52Z.2361)

## v2026.7.12 - 2026-07-23

- **Helm: external gateway entry mode.** Set `global.entry.mode: external-nginx` when an external SLB/nginx terminates TLS and forwards HTTP to Services: the chart then renders no Ingress or Certificate objects anywhere (umbrella and sub-charts) and instead renders a `<release>-nginx-routes` ConfigMap declaring every host/path → Service route for your gateway team, derived from the same values as the rest of the deployment. Requires `appRuntime.ingress.mode: gateway` (the render fails otherwise, because dynamic per-app Ingresses would have nothing serving them). Default unchanged (in-cluster Ingress, per-component flags); no action needed.
- **Helm: bring-your-own PVC and static PV binding for git-registry and VictoriaMetrics.** `gitRegistry.persistence` and `infraService.victoriaMetrics.persistentVolumeClaim` now accept `existingClaim` (reuse a pre-created PVC, chart creates none), `volumeName` (bind to a specific pre-provisioned PV; an explicit empty `storageClassName` is now emitted to disable dynamic provisioning), and `accessModes`. Edge case: an explicitly empty VictoriaMetrics `storageClassName` used to fall back to `standard-rwo` and now means the cluster default StorageClass — set `standard-rwo` explicitly if you relied on that. No action needed otherwise.
- **Helm: data PVCs survive `helm uninstall`.** The git-registry and VictoriaMetrics PVCs now carry `helm.sh/resource-policy: keep`; delete the PVC explicitly if you want the data gone. No action needed.
- **Helm: cluster-scoped RBAC can be skipped for restricted deploy accounts.** New `rbac.clusterScope.create` toggles (infra-service, opensandbox-server, its preview gateway, opensandbox-controller, registry-gc) render only the ServiceAccount/Role/RoleBinding half when false, so a namespace-scoped deploy account can install while a cluster admin pre-provisions the ClusterRole/ClusterRoleBinding half. The mirror toggle `rbac.namespaceScope.create: false` renders only the cluster half (for producing an admin bundle with `helm template`), and the release also ships that half pre-rendered as `helm/teable-infra/manifests/cluster-rbac.yaml` (next to `crds.yaml`). `infraService.rbac.knativeCompat: false` additionally drops the temporary Knative cleanup grant. Defaults unchanged; no action needed.

### Teable release.2026-07-21T04-38-35Z.2304

- Updated the README with a cover image and an improved community layout, making the project overview clearer and easier to navigate.
- Reordering columns no longer triggers a full record refresh, reducing unnecessary loading states, flickering, and duplicate requests.
- When only column metadata changes, record data now remains available from the cache, improving table responsiveness during layout adjustments.
- This also resolves related skeleton screen issues when moving columns.

[Full release notes](https://github.com/teableio/teable/releases/tag/release.2026-07-21T04-38-35Z.2304)

### Teable release.2026-07-22T11-07-01Z.2343

#### Feature Updates
- Improved the field calculation status experience with clearer progress and status changes, a simplified activity panel, and additional translations.
- Improved loading responsiveness for tables with many columns.
- Added support for path-style presigned URLs for S3-compatible storage via `BACKEND_STORAGE_S3_FORCE_PATH_STYLE`, with separate internal addressing configuration available through `BACKEND_STORAGE_S3_INTERNAL_FORCE_PATH_STYLE`.
- Teable Chat can now use authorized and @mentioned Apps as context, enabling AI assistance based on the App's code, structure, and configuration while excluding sensitive runtime configuration.

#### Bug Fixes & Improvements
- Fixed manual sorting to ensure row order remains consistent after real-time updates and page reloads.
- Fixed the self-link record selector to display only fields visible in the current connection and return complete record content.
- Reduced the maximum width of table descriptions to keep view tabs easily accessible and improve header layout.
- When updating `visibleFieldIds` via the API, link fields and link sharing configurations now always keep the linked table's primary field visible, consistent with UI behavior.
- Improved the reliability of attachment and import requests from trusted origins in runtime configuration environments.
- Fixed an issue where saving a shared Base as a copy failed when it contained plugin panels outside the sharing scope. Copies now include only shared tables and panels, and safely skip invalid panel mappings in legacy archives.
- Fixed views getting stuck in the "Calculating" state and improved recovery for formula- and Lookup-related calculations.
- Fixed formula-based Lookup fields to ensure they remain editable and convertible, and improved the reliability of loading, saving, display settings, and error handling.

[Full release notes](https://github.com/teableio/teable/releases/tag/release.2026-07-22T11-07-01Z.2343)

### Teable release.2026-07-23T08-40-34Z.2355

#### Feature Updates
- Added multiple ways to close the Kanban “Stack by” dialog: press Esc, click outside the dialog, or select “Done”.
- Added a refresh action to Audit Log and improved the display of long operator, space, and Base names.

#### Bug Fixes & Improvements
- Improved publishing consistency, ensuring that when editing, generation, and publishing operations overlap, the published app remains consistent with the latest preview without missing or overwriting newer changes.
- Optimized invitation limit handling to prevent subscribed organizations from being deactivated during legitimate bulk invitations. The hourly automatic deactivation policy no longer applies to Community Edition.
- Fixed a crash when opening “Record History” from the sidebar tree menu and clarified the meanings of the “Record History” and “Recycle Bin” labels.

[Full release notes](https://github.com/teableio/teable/releases/tag/release.2026-07-23T08-40-34Z.2355)

## v2026.7.11 - 2026-07-21

### Teable release.2026-07-20T06-51-40Z.2282

- Improved table search performance for large, high-traffic datasets, with stronger validation and safeguards for more reliable search behavior.
- Added admin controls, status visibility, and field-level usage analysis to help evaluate, enable, and manage table search optimization.
- Added bring-your-own-database (BYODB) health triage to help teams assess database-related issues more quickly and consistently.
- Added a dedicated BYODB admin page for viewing connection summaries, creating new BYODB spaces, and binding existing spaces.
- Improved BYODB migration accuracy and reliability by eliminating misleading catch-up progress and reducing write-freeze time during busy migrations.
- Improved automation email polling reliability by recovering from idle mailbox connection failures and safely discarding outdated polling results.
- Improved admin failure monitoring by grouping repeated anomalies by root cause, surfacing recent failed jobs, and providing clearer, privacy-conscious error diagnostics.
- Improved analytics attribution for signed-out, newly registered, logged-out, and returning users to prevent activity from being associated with the wrong user.
- Expanded analytics coverage for App Builder chat starts and space activity, including app and base creation, views, workflows, shares, invitations, and invitation acceptance.

[Full release notes](https://github.com/teableio/teable/releases/tag/release.2026-07-20T06-51-40Z.2282)

### Teable release.2026-07-21T00-26-02Z.2300

- Airtable imports from chat now provide clearer visible feedback by navigating to the imported table in the current base and returning links for imports into other bases.
- Improved Airtable migration reliability so stalled attachment transfers, expired downloads, interrupted API responses, and slow-but-active record reads fail or retry safely instead of leaving imports hanging.
- Personal access tokens can now use Airtable import endpoints when the target permissions and required integration scopes are valid.

- Fixed an issue where users could see “Failed to create user record” on their first OAuth sign-in to generated apps with domain or open login enabled.
- Improved the app login flow so new users are created through the app API path consistently, while existing app-token write behavior remains unaffected.

[Full release notes](https://github.com/teableio/teable/releases/tag/release.2026-07-21T00-26-02Z.2300)

## v2026.7.10 - 2026-07-20

### Changed

- **DB Pool instances can now carry a human-readable space name**: set it in
  the create dialog or via the new "set name" action on the instance detail
  page. The name shows in the instance list/detail and is propagated as a
  sanitized `teable.io/space-name` pod label, so monitoring dashboards can
  label series by space instead of the derived `dbt-*` id. Tenant Postgres
  pods also expose the CNPG metrics exporter (port 9187) via
  `prometheus.io/scrape` annotations, adding direct-connection backend counts
  to the metrics stack. Existing instances pick up the label and annotations
  in place, without a restart. No action needed.

## v2026.7.9 - 2026-07-19

### Teable release.2026-07-18T09-45-26Z.2275

- Added a visible calculation activity status for computed fields, including formulas, lookups, and rollups, so users can more clearly see when table values are still being calculated.

[Full release notes](https://github.com/teableio/teable/releases/tag/release.2026-07-18T09-45-26Z.2275)

## v2026.7.8 - 2026-07-18

### Teable release.2026-07-17T14-54-52Z.2273

`ghcr.io/teableio/teable:latest` now resolves to `release.2026-07-17T14-54-52Z.2273`.

## v2026.7.7 - 2026-07-17

### Teable release.2026-07-17T08-32-22Z.2269

`ghcr.io/teableio/teable:latest` now resolves to `release.2026-07-17T08-32-22Z.2269`.

## v2026.7.6 - 2026-07-17

### Changed

- **App Deployments now run non-root with a restricted-compliant security
  context**: generated pods set `runAsNonRoot` / `runAsUser: 1001` / seccomp
  `RuntimeDefault`, containers drop all capabilities and forbid privilege
  escalation, the app-runtime image itself runs as UID 1001, and apps unpack
  into `/tmp/app` so redeploys pinned to older runtime images keep working on
  clusters that enforce PodSecurity/Kyverno `restricted`. Override or disable
  via `infraService.appRuntime.podSecurityContext` / `containerSecurityContext`
  / `appDir` (Helm) or the matching `APP_RUNTIME_*` envs (`{}` disables).
  No action needed.

### Teable release.2026-07-17T03-42-04Z.2260

`ghcr.io/teableio/teable:latest` now resolves to `release.2026-07-17T03-42-04Z.2260`.

### Teable release.2026-07-17T05-20-38Z.2264

#### Fixes & Improvements

* **Fixed select option editing**: Clicking existing **Single select** or **Multiple select** options now opens the dropdown reliably.

* **Improved formula field stability**: Fixed failures in nested **Lookup** and **IF** formulas with certain numeric results.

* **Improved many-to-many link stability**: Fixed reverse link fields not updating promptly after large-scale background update failures.

* **Improved high-volume link field handling**: High-cardinality Link fields now calculate and display more reliably.

* **Improved formula and lookup update speed**: Multi-stage linked record updates now refresh calculations and cascades faster.

* **Improved calculation task stability**: Paused calculation tasks are no longer repeatedly awakened, reducing invalid scheduling.

* **Fixed table recycle bin menu issues**: Recycled tables now only show relevant actions like restore and delete.

* **Fixed deleted table restoration issues**: Restoring a table now only restores fields and views from that deletion.

* **Improved AI response performance**: AI Proxy SSE and streaming responses now reduce unnecessary caching and parsing.

* **Improved high-frequency background paths**: Settings reads, tracking, data cleanup, and session lookups are now lighter.

* **Enhanced session file matching checks**: Session file lookups now use stricter ID validation to reduce mismatches.

[Full release notes](https://github.com/teableio/teable/releases/tag/release.2026-07-17T05-20-38Z.2264)

## v2026.7.5 - 2026-07-16

### Changed

- **App Runtime default image** pinned to `20260716T154009Z`. No action needed.
- **App Runtime removes legacy Knative migration behavior**: generated apps continue
  to use native Kubernetes resources. Before upgrading from Knative, delete its
  remaining app resources and conflicting `ExternalName` Services; fresh installs need no action.

### Teable release.2026-07-16T10-16-45Z.2254

`ghcr.io/teableio/teable:latest` now resolves to `release.2026-07-16T10-16-45Z.2254`.

## v2026.7.4 - 2026-07-16

### Added

- **Infra Service capability handshake (`GET /api/meta`)**: the Infra Service
  now reports its build version, the OpenSandbox engine version, and
  append-only capability tokens (for example `opensandbox.v1`,
  `image-preheat.v1`, `app-runtime.gateway.v1`). Newer Teable app releases
  call this once at boot to surface infra/app compatibility in the admin
  sandbox settings and to gate the admin live test; older apps never call it,
  and an older Infra Service answering 404 is reported by the app as "infra
  too old to report capabilities", not as an outage. Compose deployments gain
  an optional `OPENSANDBOX_SERVER_IMAGE` pass-through on the Infra Service so
  `/api/meta` can report the engine version from the same tag the server
  container runs. No action needed; hot-swappable.

### Changed

- **Migration guide: the Vercel sandbox provider is hard-removed, and the
  upgrade order matters**: as of Teable `release.2026-07-01T11-07-52Z.2082`
  the Vercel sandbox provider code is gone from the app, and a leftover
  `SANDBOX_PROVIDER=vercel` makes the app container fail at boot with
  `Unknown sandbox provider type: vercel`. The migration guide now leads with
  this warning (change the environment first, then upgrade the image), notes
  that sandbox snapshots were removed in the same release (historical AI
  session workspaces migrate automatically), and adds the boot failure to the
  troubleshooting table. Action needed only if you still have
  `SANDBOX_PROVIDER=vercel` set: switch it to `opensandbox` (or remove it)
  before upgrading past that release.

## v2026.7.3 - 2026-07-15

### Added

- **Custom labels/annotations on generated app Deployments**: set
  `infraService.appRuntime.workloadLabels` / `workloadAnnotations` when your
  cluster's admission policies require specific workload metadata. Empty by
  default; no action needed.

## v2026.7.2 - 2026-07-15

### Changed

- **Kubernetes install re-verified end to end** on a clean cluster with a
  real domain. No action needed.
- **Quick start installs without `--wait`**: `helm install --wait` deadlocks
  on a first install. Install plainly and let the doctor confirm readiness;
  TROUBLESHOOTING covers recovering an already-stuck `--wait` install.

## v2026.7.1 - 2026-07-15

### Changed

- **Docker install re-verified end to end** on a clean VM with a real domain.
  No action needed.
- **Troubleshooting additions**: doctor showing `000` on the deployment VM
  itself (hosts-file workaround), and why S3 admin clients cannot connect
  through the entry (object paths only, by design).

## v2026.7.0 - 2026-07-15

First platform release — everything below ships as one verified combination.

### Added

- **Release manifest**: `versions.yaml` / `VERSIONS.md` pin every component;
  `images/README.md` covers mirrors and air-gapped installs.
- **Doctor release check**: compares what is running against `versions.yaml`
  and tells you whether the combination is verified.
- **Private CA for sandboxes**: Kubernetes via `helm/private-ca.md`; Docker
  via `SANDBOX_CA_CERT_FILE` / `SANDBOX_TLS_NO_VERIFY` in `.env`.
- **Automatic releases**: every release is tagged automatically and gets a
  GitHub Release with the matching changelog section.

### Changed

- **Docker mode `cloud` renamed to `server`** (it means "a server with a real
  domain", intranet included). If you deployed under the old name, re-run
  `./apply.sh server` once; data is untouched.
- **Sandbox engine `v0.2.0-fix6` and execd `v1.0.19-fix2`**: private-CA
  support plus an upstream permissions fix. `.env` now pins full image
  references (`EXECD_IMAGE` / `EGRESS_IMAGE`); the old `OPENSANDBOX_REGISTRY`
  variable is retired and ignored.
- **All defaults pinned**: engine images default to `ghcr.io/teableio/*`
  (China: swap the prefix for the Shenzhen mirror, same tags), MinIO is
  pinned instead of `:latest`, and bare Kubernetes installs ship a pinned
  `appRuntime.defaultImage` so app deploys work out of the box.
