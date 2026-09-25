# Install the cleanliness gates into a project.
# Usage: .\install.ps1 -Project C:\path\to\project
param(
    [Parameter(Mandatory = $true)]
    [string]$Project
)

$ErrorActionPreference = "Stop"

if (-not (Test-Path $Project -PathType Container)) {
    Write-Error "Not a directory: $Project"
    exit 2
}

$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$dest = Join-Path $Project ".claude\skills"

if (-not (Get-Command py -ErrorAction SilentlyContinue) -and -not (Get-Command python -ErrorAction SilentlyContinue)) {
    Write-Warning "No 'py' or 'python' found on PATH. The clean-user-facing-text scripts need Python 3."
}

New-Item -ItemType Directory -Force $dest | Out-Null
foreach ($name in @("humanizer", "clean-user-facing-text")) {
    $target = Join-Path $dest $name
    if (Test-Path $target) { Remove-Item -Recurse -Force $target }
    Copy-Item (Join-Path $here "skills\$name") $target -Recurse -Force
}
Get-ChildItem (Join-Path $dest "clean-user-facing-text") -Recurse -Directory -Filter "__pycache__" |
    Remove-Item -Recurse -Force

Write-Host "Installed skills to $dest"
Write-Host ""
Write-Host "Next: paste templates\CLAUDE-gates-snippet.md into $Project\CLAUDE.md"
Write-Host "and change the folder names in the 'destined for' line to match your project."
if (Test-Path (Join-Path $Project "CLAUDE.md")) {
    Write-Host "(A CLAUDE.md already exists there; append the snippet to it.)"
} else {
    Write-Host "(No CLAUDE.md found there yet; create one at the project root.)"
}
