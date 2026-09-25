# Installation guide

This installs the two cleanliness gates into any project so an assistant runs them at
every prose generation point. It takes about two minutes.

## 1. Check Python

The clean-user-facing-text scripts need Python 3. Nothing else is required.

- Windows: `py --version`
- macOS/Linux: `python3 --version`

If neither works, install Python 3 and re-check. The humanizer skill needs nothing.

## 2. Get the repo

```bash
git clone https://github.com/rileyottoklue-maker/cleanliness-gates.git
cd cleanliness-gates
```

Or download the ZIP from GitHub and unpack it.

## 3. Install into your project

### Option A: install script (recommended)

macOS/Linux:

```bash
./install.sh /path/to/your/project
```

Windows PowerShell:

```powershell
.\install.ps1 -Project C:\path\to\your\project
```

The script copies both skills into `<project>/.claude/skills/`, replaces any older
copy, and tells you whether the project already has a `CLAUDE.md`.

### Option B: copy by hand

Copy the `skills/` folder into the project's `.claude/skills/` directory. The result
should be:

```
<project>/.claude/skills/humanizer/SKILL.md
<project>/.claude/skills/clean-user-facing-text/SKILL.md
<project>/.claude/skills/clean-user-facing-text/scripts/...
<project>/.claude/skills/clean-user-facing-text/references/...
```

Windows PowerShell:

```powershell
$proj = "C:\path\to\project"
New-Item -ItemType Directory -Force "$proj\.claude\skills" | Out-Null
Copy-Item ".\skills\humanizer" "$proj\.claude\skills\humanizer" -Recurse -Force
Copy-Item ".\skills\clean-user-facing-text" "$proj\.claude\skills\clean-user-facing-text" -Recurse -Force
```

macOS/Linux:

```bash
proj="/path/to/project"
mkdir -p "$proj/.claude/skills"
cp -R ./skills/humanizer "$proj/.claude/skills/humanizer"
cp -R ./skills/clean-user-facing-text "$proj/.claude/skills/clean-user-facing-text"
```

### Option C: git submodule

If you want the gates version-pinned inside your repo:

```bash
git submodule add https://github.com/rileyottoklue-maker/cleanliness-gates.git vendor/cleanliness-gates
vendor/cleanliness-gates/install.sh .
```

Update later with `git submodule update --remote` and re-run the install script.

## 4. Wire the gates into the project rules

Open `templates/CLAUDE-gates-snippet.md` and paste its contents into the project's
`CLAUDE.md`. Create `CLAUDE.md` at the project root if there is none. If one exists,
append the snippet to the end.

Edit one line: the "destined for" list of folders. Replace `research/`, `drafts/`,
`exhibits/` with the folders your project writes prose to, such as `docs/`,
`content/`, or `notes/`.

On macOS/Linux, also replace `py` with `python3` in the two commands.

This snippet is what tells the assistant to run the gates at every step rather than
only at the end.

## 5. Verify

From the project root, run the inspector on any prose file:

- Windows: `py .claude\skills\clean-user-facing-text\scripts\inspect_text.py --stylometry --json README.md`
- macOS/Linux: `python3 .claude/skills/clean-user-facing-text/scripts/inspect_text.py --stylometry --json README.md`

A JSON report means it works. To run the deterministic clean:

```bash
py .claude/skills/clean-user-facing-text/scripts/clean_text.py INPUT -o OUTPUT --stats --no-normalize-spaces
```

Keep `--no-normalize-spaces` unless you want layout spaces (NBSP, thin spaces)
collapsed. Prefer a `*.cleaned.*` output over in-place editing unless in-place is
wanted.

## 6. Start a session

When you open the project, invoke the `humanizer` and `clean-user-facing-text` skills at
the start of any session that will produce prose, then follow the per-gate procedure in
the snippet. The order is always humanizer first, then clean-user-facing-text as the
final pass before save.

## Installing globally instead of per project

To make the gates available in every project on your machine, install to your user
skills folder instead of a project:

- Windows: `.\install.ps1 -Project $env:USERPROFILE` (this creates `%USERPROFILE%\.claude\skills\`)
- macOS/Linux: `./install.sh ~`

Then put the snippet in `~/.claude/CLAUDE.md`. Per-project CLAUDE.md files still
apply on top.

## Updating

```bash
cd cleanliness-gates
git pull
./install.sh /path/to/your/project
```

The install script replaces the skill folders and never touches your `CLAUDE.md`.

## Notes

- The `remove-ai-marks` skill from the original watermarks-remover package is not
  included. It needs a running Docker HTTP service. The self-contained
  clean-user-facing-text skill covers the same text hygiene without a service.
- The scripts are stdlib-only. No `pip install` is needed.
- Nothing here calls the network. Scoring and cleaning run locally.
