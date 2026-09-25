<!--
Paste this block into a project's CLAUDE.md to wire in the cleanliness gates.
Replace the folder names in "destined for" with the folders your project writes prose to.
Both skills must be installed at .claude/skills/ (see INSTALL.md).
On macOS/Linux, replace `py` with `python3`.
-->

## Cleanliness gates (mandatory, every session)

Every piece of generated or edited prose passes two gates before it is saved to a file
or delivered. This is a per-output gate at each generation point, not a final-pass-only
gate.

1. **humanizer** (`.claude/skills/humanizer/`) rewrites AI writing patterns:
   not-X-but-Y contrasts, one-line closers, forced triads, dashes as connectors, stock
   AI words, decorative bold, chatbot residue. No fact, number, name, or citation
   changes.
2. **clean-user-facing-text** (`.claude/skills/clean-user-facing-text/`) runs after the
   humanizer as the last step before save: a deterministic Unicode-hygiene pass plus a
   stylometry check.

Per-gate procedure for any generated or edited prose destined for
`research/`, `drafts/`, `exhibits/` (edit these to your project's folders):

1. Humanizer pass (rewrite AI patterns).
2. Measure: `py .claude/skills/clean-user-facing-text/scripts/inspect_text.py
   --stylometry --json <file>` and record the score and `density_tier`.
3. Deterministic Layer A on the humanized text:
   `py .claude/skills/clean-user-facing-text/scripts/clean_text.py <in> -o <out>
   --stats --no-normalize-spaces`
4. Save the cleaned result. Re-inspect if residual risk matters.

Operational rule: invoke both skills at the start of any session that will produce
prose, and re-check every emitted block against the strongest tells before writing it.

Scope and ethics boundary: these gates clean the SUPPORTING prose the assistant
generates (notes, feedback, draft edits, captions, formatting rewrites) to keep it free
of invisible-Unicode artifacts and AI cadence. Preserve every fact, number, name, and
citation; never invent detail; keep any required academic, legal, or platform
disclosure. This is a hygiene-and-clarity pass, not an authorship-evasion tool. For
graded, legal, or regulated work, the substance stays authored by the person
accountable for it.
