---
name: smithers
description: Durable AI workflow orchestrator. Run, monitor, and manage workflow executions. Run `smithers --help` for usage details.
requires_bin: smithers
command: smithers
---

# smithers agents add

Register a Smithers agent account (interactive wizard, or non-interactive via flags).

## Options

| Flag | Type | Default | Description |
|------|------|---------|-------------|
| `--provider` | `string` |  | Provider id; omit to launch the interactive wizard |
| `--label` | `string` |  | Unique label, e.g. 'claude-work' |
| `--configDir` | `string` |  | Path to the per-account CLI config dir (subscription providers) |
| `--apiKey` | `string` |  | API key (api-key providers only) |
| `--model` | `string` |  | Default model for this account |
| `--skipLogin` | `boolean` | `false` | Skip the 'is the dir populated?' check (advanced) |
| `--force` | `boolean` | `false` | Register even if no credentials are present |
| `--replace` | `boolean` | `false` | Overwrite an existing account with the same label |
| `--loop` | `boolean` | `false` | Wizard mode only: keep adding accounts until you say done |

---

# smithers agents capabilities

Print a JSON report of the built-in CLI agent capability registries.

---

# smithers agents doctor

Validate built-in CLI agent capability registries for drift or contradictions.

## Options

| Flag | Type | Default | Description |
|------|------|---------|-------------|
| `--json` | `boolean` | `false` | Print the doctor report as JSON |

---

# smithers agents list

List all registered Smithers agent accounts. Use --format json for machine output.

---

# smithers agents remove

Remove a Smithers agent account by label.

## Arguments

| Name | Type | Required | Description |
|------|------|----------|-------------|
| `label` | `string` | yes | Account label to remove |

## Options

| Flag | Type | Default | Description |
|------|------|---------|-------------|
| `--silent` | `boolean` | `false` | Do not error if the label is not registered |

---

# smithers agents test

Spawn the account's underlying CLI with --version to verify it is reachable.

## Arguments

| Name | Type | Required | Description |
|------|------|----------|-------------|
| `label` | `string` | yes | Account label to ping |

---

# smithers alerts

List and manage durable alert instances.

## Arguments

| Name | Type | Required | Description |
|------|------|----------|-------------|
| `action` | `string` | yes | Alert action: list, ack, resolve, or silence |
| `alertId` | `string` | no | Alert ID for ack/resolve/silence |

## Options

| Flag | Type | Default | Description |
|------|------|---------|-------------|


---

# smithers approve

Approve a paused approval gate. Auto-detects the pending node if only one exists.

## Arguments

| Name | Type | Required | Description |
|------|------|----------|-------------|
| `runId` | `string` | yes | Run ID containing the approval gate |

## Options

| Flag | Type | Default | Description |
|------|------|---------|-------------|
| `--node` | `string` |  | Node ID (required if multiple pending) |
| `--iteration` | `number` | `0` | Loop iteration number |
| `--note` | `string` |  | Approval/denial note |
| `--by` | `string` |  | Name or identifier of the approver |

---

# smithers ask

Ask a question about Smithers using your installed agent and the Smithers MCP server.

## Arguments

| Name | Type | Required | Description |
|------|------|----------|-------------|
| `question` | `string` | no | The question to ask |

## Options

| Flag | Type | Default | Description |
|------|------|---------|-------------|
| `--agent` | `string` |  | Explicitly select which agent CLI to use |
| `--listAgents` | `boolean` | `false` | List detected agents plus their bootstrap mode and exit |
| `--dumpPrompt` | `boolean` | `false` | Print the generated system prompt and exit |
| `--toolSurface` | `string` | `semantic` | Choose which Smithers MCP tool surface to expose |
| `--noMcp` | `boolean` | `false` | Disable MCP bootstrap and use prompt-only fallback |
| `--printBootstrap` | `boolean` | `false` | Print the selected bootstrap configuration and exit |

---

# smithers cancel

Safely halt agents and terminate a run.

## Arguments

| Name | Type | Required | Description |
|------|------|----------|-------------|
| `runId` | `string` | yes | Run ID to cancel |

---

# smithers chat

Show agent chat output for the latest run or a specific run.

## Arguments

| Name | Type | Required | Description |
|------|------|----------|-------------|
| `runId` | `string` | no | Run ID to inspect (default: latest run) |

## Options

| Flag | Type | Default | Description |
|------|------|---------|-------------|
| `--all` | `boolean` | `false` | Show all agent attempts in the run (default: latest only) |
| `--follow` | `boolean` | `false` | Watch for new agent output |
| `--tail` | `number` |  | Show only the last N chat blocks |
| `--stderr` | `boolean` | `true` | Include agent stderr output |

---

# smithers chat-create

Create and start a one-task auto-hijacked chat run.

## Options

| Flag | Type | Default | Description |
|------|------|---------|-------------|
| `--agent` | `string` |  | CLI agent engine to launch |
| `--cwd` | `string` |  | Working directory for the chat session (default: current directory) |

---

# smithers cron add

Register a new workflow cron schedule.

## Arguments

| Name | Type | Required | Description |
|------|------|----------|-------------|
| `pattern` | `string` | yes | Cron execution pattern (e.g. '0 * * * *') |
| `workflowPath` | `string` | yes | Path or ID of the workflow to schedule |

---

# smithers cron list

List all registered background cron schedules.

---

# smithers cron rm

Delete an existing cron schedule by ID.

## Arguments

| Name | Type | Required | Description |
|------|------|----------|-------------|
| `cronId` | `string` | yes | Cron ID to delete |

---

# smithers cron start

Start the background scheduler loop in the current terminal.

---

# smithers deny

Deny a paused approval gate.

## Arguments

| Name | Type | Required | Description |
|------|------|----------|-------------|
| `runId` | `string` | yes | Run ID containing the approval gate |

## Options

| Flag | Type | Default | Description |
|------|------|---------|-------------|
| `--node` | `string` |  | Node ID (required if multiple pending) |
| `--iteration` | `number` | `0` | Loop iteration number |
| `--note` | `string` |  | Approval/denial note |
| `--by` | `string` |  | Name or identifier of the approver |

---

# smithers diff

Print DiffBundle as unified diff.

## Arguments

| Name | Type | Required | Description |
|------|------|----------|-------------|
| `runId` | `string` | yes | Run ID containing the node |
| `nodeId` | `string` | yes | Node ID to diff |

## Options

| Flag | Type | Default | Description |
|------|------|---------|-------------|
| `--iteration` | `number` |  | Loop iteration |
| `--json` | `boolean` | `false` | Emit raw DiffBundle |
| `--stat` | `boolean` | `false` | Show stat summary only |
| `--color` | `string` | `auto` | Colorize output |

---

# smithers down

Cancel all active runs. Like 'docker compose down' for workflows.

## Options

| Flag | Type | Default | Description |
|------|------|---------|-------------|
| `--force` | `boolean` | `false` | Cancel runs even if they appear stale |

---

# smithers events

Query run event history with filters, grouping, and NDJSON output.

## Arguments

| Name | Type | Required | Description |
|------|------|----------|-------------|
| `runId` | `string` | yes | Run ID to query |

## Options

| Flag | Type | Default | Description |
|------|------|---------|-------------|
| `--node` | `string` |  | Filter events by node ID |
| `--type` | `string` |  | Filter by event category (agent, approval, frame, memory, node, openapi, output, revert, run, sandbox, scorer, snapshot, supervisor, timer, token, tool-call, workflow) |
| `--since` | `string` |  | Filter to a recent duration window (e.g. 5m, 2h) |
| `--limit` | `number` |  | Maximum events to display (default 1000, max 100000) |
| `--json` | `boolean` | `false` | Output NDJSON for piping |
| `--groupBy` | `string` |  | Group output by "node" or "attempt" |
| `--watch` | `boolean` | `false` | Watch mode: append new events as they arrive |
| `--interval` | `number` | `2` | Watch poll interval in seconds |

---

# smithers fork

Create a branched run from a snapshot checkpoint (time travel).

## Arguments

| Name | Type | Required | Description |
|------|------|----------|-------------|
| `workflow` | `string` | yes | Path to a .tsx workflow file |

## Options

| Flag | Type | Default | Description |
|------|------|---------|-------------|
| `--runId` | `string` |  | Source run ID |
| `--frame` | `number` |  | Frame number to fork from |
| `--resetNode` | `string` |  | Node ID to reset to pending |
| `--input` | `string` |  | Input overrides as JSON string |
| `--label` | `string` |  | Branch label |
| `--run` | `boolean` | `false` | Immediately start the forked run |

---

# smithers graph

Render the workflow graph without executing it.

## Arguments

| Name | Type | Required | Description |
|------|------|----------|-------------|
| `workflow` | `string` | yes | Path to a .tsx workflow file |

## Options

| Flag | Type | Default | Description |
|------|------|---------|-------------|
| `--runId` | `string` | `graph` | Run ID for context |
| `--input` | `string` |  | Input data as JSON |

---

# smithers gui

Open a directory as a workspace in Smithers GUI

## Arguments

| Name | Type | Required | Description |
|------|------|----------|-------------|
| `path` | `string` | no | Directory path (defaults to current working directory) |

## Options

| Flag | Type | Default | Description |
|------|------|---------|-------------|
| `--bundleId` | `string` | `com.smithers.SmithersGUI` | Smithers GUI app bundle identifier |

---

# smithers hijack

Hand off the latest resumable agent session or conversation for a run.

## Arguments

| Name | Type | Required | Description |
|------|------|----------|-------------|
| `runId` | `string` | yes | Run ID whose latest agent session should be hijacked |

## Options

| Flag | Type | Default | Description |
|------|------|---------|-------------|
| `--target` | `string` |  | Expected agent engine (claude-code or codex) |
| `--timeoutMs` | `number` | `30000` | How long to wait for a live run to hand off |
| `--launch` | `boolean` | `true` | Open the hijacked session immediately |

---

# smithers human

List and resolve durable human requests.

## Arguments

| Name | Type | Required | Description |
|------|------|----------|-------------|
| `action` | `string` | yes | Human request action: inbox, answer, or cancel |
| `requestId` | `string` | no | Human request ID for answer/cancel |

## Options

| Flag | Type | Default | Description |
|------|------|---------|-------------|
| `--value` | `string` |  | JSON response for smithers human answer |
| `--by` | `string` |  | Name or identifier of the human operator |

---

# smithers init

Install the local Smithers workflow pack into .smithers/.

## Options

| Flag | Type | Default | Description |
|------|------|---------|-------------|
| `--force` | `boolean` | `false` | Overwrite existing scaffold files |
| `--agentsOnly` | `boolean` | `false` | Only create .smithers/agents/ and leave the rest of the workflow pack untouched |
| `--install` | `boolean` | `true` | Run `bun install` inside .smithers/ after scaffolding (--no-install to skip) |
| `--addAgents` | `boolean` | `false` | After scaffolding, launch the interactive `agents add` wizard to register one or more accounts. |

---

# smithers inspect

Output detailed state of a run: steps, agents, approvals, and outputs.

## Arguments

| Name | Type | Required | Description |
|------|------|----------|-------------|
| `runId` | `string` | yes | Run ID to inspect |

## Options

| Flag | Type | Default | Description |
|------|------|---------|-------------|
| `--watch` | `boolean` | `false` | Watch mode: refresh output continuously |
| `--interval` | `number` | `2` | Watch refresh interval in seconds |

---

# smithers logs

Tail the event log of a specific run.

## Arguments

| Name | Type | Required | Description |
|------|------|----------|-------------|
| `runId` | `string` | yes | Run ID to tail |

## Options

| Flag | Type | Default | Description |
|------|------|---------|-------------|
| `--follow` | `boolean` | `true` | Keep tailing (default true for active runs) |
| `--since` | `number` |  | Start from event sequence number |
| `--tail` | `number` | `50` | Show last N events first |
| `--followAncestry` | `boolean` | `false` | Include events from ancestor runs (continuation lineage) |

---

# smithers memory list

List all memory facts in a namespace.

## Arguments

| Name | Type | Required | Description |
|------|------|----------|-------------|
| `namespace` | `string` | yes | Namespace to list facts for (e.g. 'workflow:my-flow') |

## Options

| Flag | Type | Default | Description |
|------|------|---------|-------------|
| `--workflow` | `string` |  | Path to a .tsx workflow file |

---

# smithers node

Show enriched node details for debugging retries, tool calls, and output.

## Arguments

| Name | Type | Required | Description |
|------|------|----------|-------------|
| `nodeId` | `string` | yes | Node ID to inspect |

## Options

| Flag | Type | Default | Description |
|------|------|---------|-------------|
| `--runId` | `string` |  | Run ID containing the node |
| `--iteration` | `number` |  | Loop iteration number (default: latest iteration) |
| `--attempts` | `boolean` | `false` | Expand all attempts in human output |
| `--tools` | `boolean` | `false` | Expand tool input/output payloads in human output |
| `--watch` | `boolean` | `false` | Watch mode: refresh output continuously |
| `--interval` | `number` | `2` | Watch refresh interval in seconds |

---

# smithers observability

Start the local observability stack (Grafana, Prometheus, Tempo, OTLP Collector) via Docker Compose.

## Options

| Flag | Type | Default | Description |
|------|------|---------|-------------|
| `--detach` | `boolean` | `false` | Run containers in the background |
| `--down` | `boolean` | `false` | Stop and remove the observability stack |

---

# smithers openapi list

Preview tools that would be generated from an OpenAPI spec.

## Arguments

| Name | Type | Required | Description |
|------|------|----------|-------------|
| `specPath` | `string` | yes | Path or URL to an OpenAPI spec |

---

# smithers output

Print node output row.

## Arguments

| Name | Type | Required | Description |
|------|------|----------|-------------|
| `runId` | `string` | yes | Run ID containing the node |
| `nodeId` | `string` | yes | Node ID to fetch output for |

## Options

| Flag | Type | Default | Description |
|------|------|---------|-------------|
| `--iteration` | `number` |  | Loop iteration |
| `--json` | `boolean` | `true` | Emit raw row as JSON |
| `--pretty` | `boolean` | `false` | Schema-ordered render |

---

# smithers ps

List active, paused, and recently completed runs.

## Options

| Flag | Type | Default | Description |
|------|------|---------|-------------|
| `--status` | `string` |  | Filter by status: running, waiting-approval, waiting-event, waiting-timer, continued, finished, failed, cancelled |
| `--limit` | `number` | `20` | Maximum runs to return |
| `--all` | `boolean` | `false` | Include all statuses |
| `--watch` | `boolean` | `false` | Watch mode: refresh output continuously |
| `--interval` | `number` | `2` | Watch refresh interval in seconds |

---

# smithers replay

Fork from a checkpoint and resume execution (time travel).

## Arguments

| Name | Type | Required | Description |
|------|------|----------|-------------|
| `workflow` | `string` | yes | Path to a .tsx workflow file |

## Options

| Flag | Type | Default | Description |
|------|------|---------|-------------|
| `--runId` | `string` |  | Source run ID to replay from |
| `--frame` | `number` |  | Frame number to fork from |
| `--node` | `string` |  | Node ID to reset to pending |
| `--input` | `string` |  | Input overrides as JSON string |
| `--label` | `string` |  | Branch label for the fork |
| `--restoreVcs` | `boolean` | `false` | Restore jj filesystem state to the source frame's revision |

---

# smithers retry-task

Retry a specific task within a run, then resume the workflow.

## Arguments

| Name | Type | Required | Description |
|------|------|----------|-------------|
| `workflow` | `string` | yes | Path to a .tsx workflow file |

## Options

| Flag | Type | Default | Description |
|------|------|---------|-------------|
| `--runId` | `string` |  | Run ID containing the task |
| `--nodeId` | `string` |  | Task/node ID to retry |
| `--iteration` | `number` | `0` | Loop iteration |
| `--noDeps` | `boolean` | `false` | Only reset this node, not dependents |
| `--force` | `boolean` | `false` | Allow retry even if run is still running |

---

# smithers revert

Revert the workspace to a previous task attempt's filesystem state.

## Arguments

| Name | Type | Required | Description |
|------|------|----------|-------------|
| `workflow` | `string` | yes | Path to a .tsx workflow file |

## Options

| Flag | Type | Default | Description |
|------|------|---------|-------------|
| `--runId` | `string` |  | Run ID to revert |
| `--nodeId` | `string` |  | Node ID to revert to |
| `--attempt` | `number` | `1` | Attempt number |
| `--iteration` | `number` | `0` | Loop iteration number |

---

# smithers rewind

Rewind a run to a previous frame.

## Arguments

| Name | Type | Required | Description |
|------|------|----------|-------------|
| `runId` | `string` | yes | Run ID to rewind |
| `frameNo` | `number` | yes | Target frame number |

## Options

| Flag | Type | Default | Description |
|------|------|---------|-------------|
| `--yes` | `boolean` | `false` | Skip confirmation |
| `--json` | `boolean` | `false` | Emit JumpResult JSON |

---

# smithers scores

View scorer results for a specific run.

## Arguments

| Name | Type | Required | Description |
|------|------|----------|-------------|
| `runId` | `string` | yes | Run ID to inspect |

## Options

| Flag | Type | Default | Description |
|------|------|---------|-------------|
| `--node` | `string` |  | Filter scores to a specific node ID |

---

# smithers signal

Deliver a durable signal to a run waiting on <Signal> or <WaitForEvent>.

## Arguments

| Name | Type | Required | Description |
|------|------|----------|-------------|
| `runId` | `string` | yes | Run ID containing the waiting signal |
| `signalName` | `string` | yes | Signal name to deliver |

## Options

| Flag | Type | Default | Description |
|------|------|---------|-------------|
| `--data` | `string` |  | Signal payload as JSON (default: {}) |
| `--correlation` | `string` |  | Correlation ID to match a specific waiter |
| `--by` | `string` |  | Name or identifier of the signal sender |

---

# smithers supervise

Watch for stale running runs and auto-resume them.

## Options

| Flag | Type | Default | Description |
|------|------|---------|-------------|
| `--dryRun` | `boolean` | `false` | Show which stale runs would be resumed, without acting |
| `--interval` | `string` | `10s` | Poll interval (e.g. 10s, 30s, 1m) |
| `--staleThreshold` | `string` | `30s` | Heartbeat staleness threshold before resume |
| `--maxConcurrent` | `number` | `3` | Max runs resumed per poll |

---

# smithers timeline

View execution timeline for a run and its forks (time travel).

## Arguments

| Name | Type | Required | Description |
|------|------|----------|-------------|
| `runId` | `string` | yes | Run ID |

## Options

| Flag | Type | Default | Description |
|------|------|---------|-------------|
| `--tree` | `boolean` | `false` | Include all child forks recursively |
| `--json` | `boolean` | `false` | Output as JSON |

---

# smithers timetravel

Time-travel to a previous task state: revert filesystem, reset DB, and optionally resume.

## Arguments

| Name | Type | Required | Description |
|------|------|----------|-------------|
| `workflow` | `string` | yes | Path to a .tsx workflow file |

## Options

| Flag | Type | Default | Description |
|------|------|---------|-------------|
| `--runId` | `string` |  | Run ID |
| `--nodeId` | `string` |  | Task/node ID to travel back to |
| `--iteration` | `number` | `0` | Loop iteration |
| `--attempt` | `number` |  | Attempt number (default: latest) |
| `--noVcs` | `boolean` | `false` | Skip filesystem revert (DB only) |
| `--noDeps` | `boolean` | `false` | Only reset this node, not dependents |
| `--resume` | `boolean` | `false` | Resume the workflow after time travel |
| `--force` | `boolean` | `false` | Force even if run is still running |

---

# smithers token issue

Issue a local short-lived Gateway bearer token grant.

## Options

| Flag | Type | Default | Description |
|------|------|---------|-------------|
| `--scopes` | `string` | `run:read` | Comma or space separated Gateway scopes |
| `--role` | `string` | `operator` | Role recorded on the token grant |
| `--userId` | `string` |  | User id recorded on the token grant |
| `--ttl` | `string` | `1h` | Token lifetime, such as 15m or 1h |

---

# smithers token revoke

Revoke a locally issued Gateway bearer token.

## Arguments

| Name | Type | Required | Description |
|------|------|----------|-------------|
| `token` | `string` | yes | Bearer token to revoke |

---

# smithers tree

Print DevTools snapshot as XML tree.

## Arguments

| Name | Type | Required | Description |
|------|------|----------|-------------|
| `runId` | `string` | yes | Run ID to inspect |

## Options

| Flag | Type | Default | Description |
|------|------|---------|-------------|
| `--frame` | `number` |  | Historical frame number |
| `--watch` | `boolean` | `false` | Stream live events |
| `--json` | `boolean` | `false` | Emit snapshot JSON |
| `--depth` | `number` |  | Truncate depth |
| `--node` | `string` |  | Scope to subtree |
| `--color` | `string` | `auto` | Colorize output |

---

# smithers tui

Open the interactive Smithers observability dashboard

---

# smithers up

Start a workflow execution. Use -d for detached (background) mode.

## Arguments

| Name | Type | Required | Description |
|------|------|----------|-------------|
| `workflow` | `string` | yes | Path to a .tsx workflow file |

## Options

| Flag | Type | Default | Description |
|------|------|---------|-------------|
| `--detach` | `boolean` | `false` | Run in background, print run ID, exit |
| `--runId` | `string` |  | Explicit run ID |
| `--maxConcurrency` | `number` |  | Maximum parallel tasks (default: 4) |
| `--root` | `string` |  | Tool sandbox root directory |
| `--log` | `boolean` | `true` | Enable NDJSON event log file output |
| `--logDir` | `string` |  | NDJSON event logs directory |
| `--allowNetwork` | `boolean` | `false` | Allow bash tool network requests |
| `--maxOutputBytes` | `number` |  | Max bytes a single tool call can return |
| `--toolTimeoutMs` | `number` |  | Max wall-clock time per tool call in ms |
| `--hot` | `boolean` | `false` | Enable hot module replacement for .tsx workflows |
| `--input` | `string` |  | Input data as JSON string |
| `--annotations` | `string` |  | Run annotations as a flat JSON object of string/number/boolean values |
| `--resume` | `unknown` | `false` | Resume a previous run. Pass true with --run-id, or pass the run ID directly (e.g. --resume <run-id>) |
| `--force` | `boolean` | `false` | Resume even if still marked running |
| `--resumeClaimOwner` | `string` |  | Internal durable resume claim owner |
| `--resumeClaimHeartbeat` | `number` |  | Internal durable resume claim heartbeat |
| `--resumeRestoreOwner` | `string` |  | Internal durable resume restore owner |
| `--resumeRestoreHeartbeat` | `number` |  | Internal durable resume restore heartbeat |
| `--serve` | `boolean` | `false` | Start an HTTP server alongside the workflow |
| `--supervise` | `boolean` | `false` | Run the stale-run supervisor loop (with --serve) |
| `--superviseDryRun` | `boolean` | `false` | With --supervise, detect stale runs without resuming |
| `--superviseInterval` | `string` | `10s` | With --supervise, poll interval (e.g. 10s, 30s) |
| `--superviseStaleThreshold` | `string` | `30s` | With --supervise, stale heartbeat threshold |
| `--superviseMaxConcurrent` | `number` | `3` | With --supervise, max runs resumed per poll |
| `--port` | `number` | `7331` | HTTP server port (with --serve) |
| `--host` | `string` | `127.0.0.1` | HTTP server bind address (with --serve) |
| `--authToken` | `string` |  | Bearer token for HTTP auth (or set SMITHERS_API_KEY) |
| `--metrics` | `boolean` | `true` | Expose /metrics endpoint (with --serve) |

---

# smithers why

Explain why a run is currently blocked or paused.

## Arguments

| Name | Type | Required | Description |
|------|------|----------|-------------|
| `runId` | `string` | yes | Run ID to explain |

## Options

| Flag | Type | Default | Description |
|------|------|---------|-------------|
| `--json` | `boolean` | `false` | Output structured JSON diagnosis |

---

# smithers workflow create

Create a new flat workflow scaffold in .smithers/workflows.

## Arguments

| Name | Type | Required | Description |
|------|------|----------|-------------|
| `name` | `string` | yes | Workflow ID |

---

# smithers workflow doctor

Inspect workflow discovery, preload files, and detected agents.

## Arguments

| Name | Type | Required | Description |
|------|------|----------|-------------|
| `name` | `string` | no | Workflow ID |

---

# smithers workflow list

List discovered local workflows.

---

# smithers workflow path

Resolve a workflow ID to its entry file.

## Arguments

| Name | Type | Required | Description |
|------|------|----------|-------------|
| `name` | `string` | yes | Workflow ID |

---

# smithers workflow run

Run a discovered workflow by ID.

## Arguments

| Name | Type | Required | Description |
|------|------|----------|-------------|
| `name` | `string` | yes | Workflow ID |

## Options

| Flag | Type | Default | Description |
|------|------|---------|-------------|
| `--detach` | `boolean` | `false` | Run in background, print run ID, exit |
| `--runId` | `string` |  | Explicit run ID |
| `--maxConcurrency` | `number` |  | Maximum parallel tasks (default: 4) |
| `--root` | `string` |  | Tool sandbox root directory |
| `--log` | `boolean` | `true` | Enable NDJSON event log file output |
| `--logDir` | `string` |  | NDJSON event logs directory |
| `--allowNetwork` | `boolean` | `false` | Allow bash tool network requests |
| `--maxOutputBytes` | `number` |  | Max bytes a single tool call can return |
| `--toolTimeoutMs` | `number` |  | Max wall-clock time per tool call in ms |
| `--hot` | `boolean` | `false` | Enable hot module replacement for .tsx workflows |
| `--input` | `string` |  | Input data as JSON string |
| `--annotations` | `string` |  | Run annotations as a flat JSON object of string/number/boolean values |
| `--resume` | `unknown` | `false` | Resume a previous run. Pass true with --run-id, or pass the run ID directly (e.g. --resume <run-id>) |
| `--force` | `boolean` | `false` | Resume even if still marked running |
| `--resumeClaimOwner` | `string` |  | Internal durable resume claim owner |
| `--resumeClaimHeartbeat` | `number` |  | Internal durable resume claim heartbeat |
| `--resumeRestoreOwner` | `string` |  | Internal durable resume restore owner |
| `--resumeRestoreHeartbeat` | `number` |  | Internal durable resume restore heartbeat |
| `--serve` | `boolean` | `false` | Start an HTTP server alongside the workflow |
| `--supervise` | `boolean` | `false` | Run the stale-run supervisor loop (with --serve) |
| `--superviseDryRun` | `boolean` | `false` | With --supervise, detect stale runs without resuming |
| `--superviseInterval` | `string` | `10s` | With --supervise, poll interval (e.g. 10s, 30s) |
| `--superviseStaleThreshold` | `string` | `30s` | With --supervise, stale heartbeat threshold |
| `--superviseMaxConcurrent` | `number` | `3` | With --supervise, max runs resumed per poll |
| `--port` | `number` | `7331` | HTTP server port (with --serve) |
| `--host` | `string` | `127.0.0.1` | HTTP server bind address (with --serve) |
| `--authToken` | `string` |  | Bearer token for HTTP auth (or set SMITHERS_API_KEY) |
| `--metrics` | `boolean` | `true` | Expose /metrics endpoint (with --serve) |
| `--prompt` | `string` |  | Prompt text mapped to input.prompt when --input is omitted |
