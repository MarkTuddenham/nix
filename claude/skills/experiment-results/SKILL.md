---
name: experiment-results
description: >
  Updates the Results section of an existing numbered entry in docs/experiments/run-log.md.
  Use when the user says "update experiment N with results", "log results for EXP-NNN",
  "record the outcome of experiment N", pastes a screenshot or graph of training curves, or
  similar — typically after a training run has finished.
---

# Experiment Results

Fills in the `### Results` section of an existing `EXP-NNN` entry and marks it complete.

## Steps

1. **Identify the experiment.**
   - If the user names a number (e.g. "experiment 3", "EXP-003"), use that.
   - If the user pastes an image without a number, read `docs/experiments/run-log.md`, find the
     most recent entry with `Status: running`, and use its number. Confirm with the user before
     proceeding: `"Updating EXP-NNN — is that right?"`

2. **Handle a pasted image.**
   If the user has attached an image (screenshot of training graphs):
   - Save it to `docs/experiments/figures/exp-NNN-results.png`.
   - Analyse the image: read axis labels, legend entries, and curve shapes. Extract key
     values — final reward, approximate convergence step, notable spikes or plateaus, and
     anything that looks like a pass/fail signal.
   - Write a short prose paragraph (3–5 sentences) summarising what the graphs show.

3. **Collect additional context (one question only).**
   If the verdict or key metrics are not clear from the image or the user's message, ask a
   single follow-up: `"Any verdict or extra metrics to record? (e.g. 'pass — reward converged
   to 0.6', or 'abandoned — reward collapsed at step 4000')"`. Do not ask if the user already
   stated a verdict.

4. **Read and locate the entry.**
   Read `docs/experiments/run-log.md`. Find the `## EXP-NNN` heading. The Results block to
   replace is:
   ```
   ### Results
   *Pending.*
   ```
   If the Results block is already filled in, append a `#### Update` subsection instead of
   overwriting.

5. **Write the results block.**
   Replace the pending block with:

   ```markdown
   ### Results
   *Completed: YYYY-MM-DD*

   ![Training curves](figures/exp-NNN-results.png)

   <prose summary from image analysis>

   | Metric | Value |
   |---|---|
   | <metric> | <value> |

   **Verdict:** Pass / Fail / Inconclusive — <one-sentence reason>
   ```

   - Omit the `![Training curves]` line if no image was provided.
   - Omit the table if no numeric metrics were given.
   - Keep the verdict line even if it is just `Inconclusive — results pending review`.

6. **Update the status line.**
   Change `Status: running` to `Status: complete` in the entry header. Use `abandoned` if the
   user indicated the run was stopped early.

7. **Report.** Tell the user: `EXP-NNN results recorded`.
