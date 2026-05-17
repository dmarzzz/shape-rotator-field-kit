---
name: shape-rotator-profile
description: Add or update your profile in the Shape Rotator OS cohort. Walks the user through profile fields, finds their existing record if any, and opens a PR against dmarzzz/shape-rotator-field-guide. Use when the user says they want to "add my profile to shape rotator", "set up my cohort entry", "update my srfg profile", or anything similar.
---

# shape-rotator-profile

Add or update a person record in the Shape Rotator OS cohort
(`cohort-data/people/<slug>.md` in `dmarzzz/shape-rotator-field-guide`)
and open a PR.

## When to invoke

The user said something like:
- "add my profile to shape rotator"
- "set up my cohort entry"
- "update my shape rotator profile"
- "i'm in the cohort, get my profile in"

## Preconditions — check these first, stop early if missing

1. `gh` CLI is installed: `command -v gh >/dev/null` — if not, tell the
   user to install (`brew install gh` on macOS) and stop.
2. `gh` is authenticated: `gh auth status` — if not, tell the user to
   run `gh auth login` (web flow, GitHub.com scope) and stop.
3. Their GitHub login is reachable: `gh api user --jq .login`. Save this
   as `$GH_LOGIN` for later steps.

## Workflow

### 1 — ask for their name

Just: "what name should I look for in the cohort?" Free-text.

### 2 — find their existing record

Fetch the people directory:
```bash
gh api /repos/dmarzzz/shape-rotator-field-guide/contents/cohort-data/people --jq '.[] | {name: .name, sha: .sha, path: .path}'
```

For each `<slug>.md`, fetch the raw content via:
```bash
gh api -H "Accept: application/vnd.github.raw" /repos/dmarzzz/shape-rotator-field-guide/contents/cohort-data/people/<slug>.md
```

Match candidates where any of:
- `name:` frontmatter contains the user's input (case-insensitive substring)
- `record_id:` matches a kebab-case slug of the input
- `links.github:` matches `$GH_LOGIN`

If **exactly one** match: confirm with the user ("found you as
`<record_id>` — is that you?"). On yes → EDIT mode. Save the file's
`sha` (you'll need it for the PUT call).

If **multiple** matches: list them with record_id + name, let the user
pick one. EDIT mode.

If **no match**: ADD mode. Generate a slug from their name (lowercase,
ascii-only, spaces → `-`, strip punctuation).

### 3 — interview

Show the user the schema once at the start so they know what's coming:

> i'll ask for the canonical fields plus a few optional ones. say
> "skip" to leave any optional field blank.

**Required** (must have a non-empty answer):
- **name** — display name (e.g. "Ada Lovelace"). For EDITs, default to existing.
- **team** — controlled vocab. Fetch the list:
  ```bash
  gh api /repos/dmarzzz/shape-rotator-field-guide/contents/cohort-data/teams --jq '.[].name' | sed 's/\.md$//'
  ```
  Show numbered, let user pick or type a new slug. If new, warn that
  it'll need a matching team record (which this skill does NOT create).
- **role** — short text ("lead", "researcher", "designer", "engineer")
- **geo** — where they're based ("NYC", "Berlin/remote", etc.)
- **domain** — controlled vocab: `crypto | tee | ai | app-ux | bd-gtm | design`
- **links.github** — default to `$GH_LOGIN`, let them override

**Optional** (any can be empty/skip):
- email
- links.x — twitter / X handle, no `@`
- links.website
- links.linkedin
- comm_style — multi-line; how to reach you, sync vs async, response cadence
- contribute_interests — multi-line; what you'd happily pair on
- availability_pref — multi-line; heads-down hours, no-meet days
- weekly_intention — one concrete thing you want to ship/learn this week
- now — one-line current focus (Sivers `/now`-page pattern)

For **EDIT mode**: print every existing field's current value alongside
the question. Accept "keep" to retain. Only re-ask for empty/null fields
by default; offer "type 'change' to update any other field."

### 4 — build the markdown

Frontmatter shape (omit empty/null fields except where the schema
expects them):

```yaml
---
record_id: <slug>
record_type: person
schema_version: 1
name: "<name>"
team: <team-slug>
role: "<role>"
geo: "<geo>"
domain: <domain>
email: <email>            # only if provided
dates_start: <YYYY-MM-DD> # preserve from existing on EDIT
dates_end: <YYYY-MM-DD>   # preserve from existing on EDIT
secondary_teams:          # preserve from existing on EDIT
  - <slug>
links:
  github: <handle>
  x: <handle>             # only if provided
  website: <url>          # only if provided
  linkedin: <handle>      # only if provided
comm_style: |             # block scalar; only if non-empty
  ...
contribute_interests: |
  ...
availability_pref: |
  ...
weekly_intention: "<one line>"
now: "<one line>"         # only if provided
---

## bio

<bio paragraph; preserve existing body on EDIT verbatim>
```

**EDIT mode rules:**
- NEVER drop fields you don't recognize — copy them through from the
  existing file.
- Preserve `email`, `dates_start`, `dates_end`, `secondary_teams`,
  `absences`, `skills`, `skill_areas`, `seeking`, `offering`,
  `pair_with`, `prior_shipping` if present.
- Preserve the body (everything after the second `---`) verbatim
  unless the user explicitly asked to rewrite it.

YAML-quote anything with punctuation or that starts with a digit. Empty
values become `null` (don't write `""`).

### 5 — open the PR

```bash
# Ensure fork exists. The unauthenticated check is cheap; if it 404s,
# create the fork. --remote=false / --clone=false because we don't need
# a local clone — we're going through the API.
if ! gh api /repos/$GH_LOGIN/shape-rotator-field-guide >/dev/null 2>&1; then
  gh repo fork dmarzzz/shape-rotator-field-guide --remote=false --clone=false
  # forks take ~3 seconds to materialize; poll briefly.
  for i in 1 2 3 4 5; do
    sleep 2
    gh api /repos/$GH_LOGIN/shape-rotator-field-guide >/dev/null 2>&1 && break
  done
fi

# Branch name — unique per submission so re-runs don't collide.
BRANCH="profile/$SLUG-$(date +%Y%m%d-%H%M%S)"

# Get the head sha of the fork's main so we can create a branch.
MAIN_SHA=$(gh api /repos/$GH_LOGIN/shape-rotator-field-guide/git/refs/heads/main --jq .object.sha)
gh api -X POST /repos/$GH_LOGIN/shape-rotator-field-guide/git/refs \
  -f ref="refs/heads/$BRANCH" -f sha="$MAIN_SHA"

# Put the file. For EDITs, pass the existing file's sha; for ADDs, omit.
# Content is base64-encoded.
B64=$(echo -n "$MARKDOWN" | base64)
ARGS=(-X PUT "/repos/$GH_LOGIN/shape-rotator-field-guide/contents/cohort-data/people/$SLUG.md"
  -f message="profile: $MODE $SLUG"
  -f content="$B64"
  -f branch="$BRANCH")
[ -n "$EXISTING_SHA" ] && ARGS+=(-f sha="$EXISTING_SHA")
gh api "${ARGS[@]}"

# Open the PR.
gh pr create --repo dmarzzz/shape-rotator-field-guide \
  --head "$GH_LOGIN:$BRANCH" --base main \
  --title "profile: $MODE $SLUG" \
  --body "Submitted via the shape-rotator-profile skill.

Fields changed:
- ..."
```

Print the PR URL to the user.

## Boundaries

- **Don't** include financial info, salary, internal team notes, or
  anything from a private CRM. This is a public-facing cohort record.
- **Don't** invent values. If the user skips a field, leave it null.
- **Don't** create team records — only people. If they say their team
  doesn't exist yet, tell them to coordinate with the cohort steward.
- **Stop early** if `gh` isn't installed or authenticated. Don't try to
  workaround with HTTPS / curl / token-based auth.
- **One PR per run.** If the user wants to submit multiple records,
  invoke the skill again.
