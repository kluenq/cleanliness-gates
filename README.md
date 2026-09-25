# Cleanliness gates

Two drop-in skills for Claude Code that clean every piece of generated or edited prose
before it is saved to a file. They run at each generation point, not only as a final
pass, so AI cadence and invisible Unicode never reach your repo.

```
git clone https://github.com/rileyottoklue-maker/cleanliness-gates.git
cd cleanliness-gates
./install.sh /path/to/your/project        # macOS / Linux
.\install.ps1 -Project C:\path\to\project  # Windows
```

Then paste [templates/CLAUDE-gates-snippet.md](templates/CLAUDE-gates-snippet.md) into
your project's `CLAUDE.md`. Full steps are in [INSTALL.md](INSTALL.md).

## What is in this repo

```
cleanliness-gates/
  README.md                  this file
  INSTALL.md                 step-by-step install into any project
  LICENSE                    MIT, with third-party notices
  install.sh                 one-command install (macOS / Linux)
  install.ps1                one-command install (Windows PowerShell)
  skills/
    humanizer/               rewrites AI writing patterns (style)
    clean-user-facing-text/  deterministic Unicode hygiene + stylometry score
  templates/
    CLAUDE-gates-snippet.md  paste-in block that wires the gates into a project
```

## The two gates

The gates run in order at every point where prose is produced or edited:

1. **humanizer** rewrites AI writing patterns: not-X-but-Y contrasts, one-line closers,
   forced triads, dashes as connectors, stock AI words, decorative bold, chatbot
   residue. It works on writing style. It changes no fact, number, name, or citation.

2. **clean-user-facing-text** runs after the humanizer as the last step before save. It
   does a deterministic Unicode pass (strips invisible characters, homoglyphs, and
   stray smart quotes so printed or pasted output renders cleanly) and records a
   stylometry score you can compare before and after. It is self-contained: it runs its
   own vendored Python and needs no network or service.

The two are complementary. The first works on style; the second works on invisible
characters and gives a measurable gauge.

## How it fits into a workflow

Once installed, the assistant loads both skills at the start of any session that will
write prose. For each block of text it generates or edits, it:

1. Runs the humanizer rewrite.
2. Measures the text with `inspect_text.py --stylometry` and records the score.
3. Runs the deterministic Unicode clean with `clean_text.py`.
4. Saves the cleaned result.

The CLAUDE.md snippet is what makes this mandatory per output rather than an
occasional final pass. You choose which folders it applies to by editing one line in
the snippet.

## Requirements

- Python 3 on PATH, reachable as `py` (Windows) or `python3` (macOS/Linux). The
  clean-user-facing-text scripts are stdlib-only and need no packages. The humanizer
  skill is instructions only and needs nothing.
- Claude Code, or any assistant that reads `.claude/skills/*/SKILL.md` and `CLAUDE.md`.

## Quick check

From a project that has installed the skills:

```bash
py .claude/skills/clean-user-facing-text/scripts/inspect_text.py --stylometry --json path/to/file.md
```

A JSON report with a `score`, `density_tier`, and any flagged spans means the setup
works. Use `python3` instead of `py` on macOS and Linux.

## What these gates are for, and what they are not

Use them to keep the supporting prose an assistant generates (notes, feedback, draft
edits, captions, formatting rewrites) free of invisible-Unicode artifacts and AI
cadence before it lands in a file. Both skills preserve every fact, number, name,
citation, and required disclosure, and neither invents detail.

These are a hygiene-and-clarity pass, not an authorship-evasion tool. The
clean-user-facing-text skill states this in its own rules: do not use it for
undisclosed authorship evasion, and keep required academic, legal, and platform
disclosures. A lower stylometry score means the measured signals moved. It is not proof
that text reads as human-written and it is not a verdict from any detector. For
graded, legal, or regulated work, keep the substance authored by the person who is
accountable for it, and apply these gates only to assistant-generated helper text.

## Updating

Pull the latest version and re-run the install script against your project. The
script replaces both skill folders under `.claude/skills/` and leaves your `CLAUDE.md`
untouched.

## Sources and license

MIT. See [LICENSE](LICENSE) for the third-party notices.

- humanizer: https://github.com/blader/humanizer (MIT). Patterns from Wikipedia's
  "Signs of AI writing".
- clean-user-facing-text: from the watermarks-remover package,
  https://github.com/guillaumemeyer/watermarks-remover (MIT). This repo includes
  only the self-contained skill, not the service-dependent `remove-ai-marks` skill.
