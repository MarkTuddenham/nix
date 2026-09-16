---
name: experiment-log
description: >
  Creates a new numbered entry in docs/experiments/run-log.md capturing what changed and the
  hypothesis for a training run. Use when the user says "log this experiment", "create an
  experiment entry", "record these changes as an experiment", or similar — typically before
  starting a training run after modifying config or code.
---

# Experiment Log

Records a new numbered experiment entry so training runs can be tracked, referred to by number,
and later updated with results.

## What to produce

A new `## EXP-NNN` section appended to `docs/experiments/run-log.md`, where NNN is zero-padded
to three digits and one higher than the largest existing number (or `001` if the file does not
yet exist).

## Steps

1. **Read the log file.** Read `docs/experiments/run-log.md`.
   - If it does not exist, the file starts with `# Experiment Run Log\n\n` and the first entry
     is `EXP-001`.
   - Otherwise, find the highest `EXP-NNN` heading to determine the next number.

2. **Capture the git ref.** Run:
   ```bash
   git rev-parse HEAD
   git branch --show-current
   ```
   Record the full commit SHA and branch name. Both go in the entry header so the exact code
   state is always reproducible, even after the branch moves on.

3. **Analyse the diff — semantic changes only.** Run:
   ```bash
   git diff HEAD
   git status --short
   ```
   Read the full diff, then filter it mentally before writing anything:

   **Discard as structural (do not mention):**
   - Import reordering or grouping
   - Formatting, whitespace, and line-length fixes
   - Renames or moves that preserve behaviour
   - Comment additions or removals
   - Type annotation changes that do not alter runtime behaviour
   - Refactors that produce identical outputs for all inputs

   **Keep as semantic (do mention):**
   - Changed hyperparameter values
   - New or removed reward terms, observation fields, or action choices
   - Logic changes in environment step, reset, or termination
   - New or removed network layers, heads, or architectures
   - Curriculum or schedule changes
   - Anything that would make two training runs diverge given the same seed

   Write a short prose paragraph (3–6 sentences) covering only the semantic changes.
   If everything in the diff is structural, state that explicitly: "No semantic changes —
   this run uses the same logic and config as the previous experiment."

4. **Extract the config snapshot.** Read
   `src/hs_regatta/scenarios/contested/config/contested_config.yaml`. List only the
   hyperparameters that the diff touched or that differ from the previous experiment's snapshot.
   Format as a compact key–value list (not a full YAML dump). If nothing changed, write
   `Unchanged from EXP-NNN`.

5. **Identify the overarching experiment.** List the experiment plan files:
   ```bash
   ls docs/experiments/
   ```
   Exclude `run-log.md` and `README.md`. Present the remaining filenames as options (e.g.
   `04a-contested-search`, `week-1-experiments`). Check whether the most recent entry in
   `run-log.md` already has an `Experiment:` tag — if so, offer that as the default.

   If the user has not already named the experiment, ask which plan this run belongs to.
   Accept short names (`04A`, `week-1`) and resolve them to the matching filename.

6. **Gather title, hypothesis, and Phoenix run name.** If the user has not already stated them,
   ask one question with three parts:
   - A short title (5–10 words) for this run.
   - Their hypothesis: what they expect training to show.
   - The Phoenix run name, if they have one (e.g. `friendly-jennings-13418`), or `none` to skip.

   The Phoenix run name is optional — do not block on it. If provided, derive the Comet URL:
   1. Strip all hyphens from the run name: `friendly-jennings-13418` → `friendlyjennings13418`
   2. Concatenate that string with itself: `friendlyjennings13418friendlyjennings13418`
   3. Prepend the base URL: `https://comet.helsing-dev.ai/hs-all/tempest/<doubled-slug>`

   Example: `friendly-jennings-13418` →
   `https://comet.helsing-dev.ai/hs-all/tempest/friendlyjennings13418friendlyjennings13418`

7. **Append the entry.** Write the block below to the end of `docs/experiments/run-log.md`,
   creating the file first if needed.

```markdown
## EXP-NNN — <title>
*Date: YYYY-MM-DD | Branch: <branch> | Ref: `<short SHA>` | Experiment: <plan name> | Status: running*
*Phoenix: `<run-name>` | Comet: <URL or —>*

### Changes
<prose summary of semantic changes from step 3>

### Config snapshot
<key hyperparameter list from step 4>

### Hypothesis
<hypothesis from step 5>

### Results
*Pending.*

---
```

8. **Report.** Tell the user: `EXP-NNN logged in docs/experiments/run-log.md`.
