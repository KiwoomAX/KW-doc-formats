#Requires -Version 7.0
# Contract tests for the kw-doc-formats plugin.
#   pwsh -NoProfile -ExecutionPolicy Bypass -File .\tests\test_plugin.ps1

$ErrorActionPreference = 'Stop'
$Root = Split-Path -Parent $PSScriptRoot

$script:Pass = 0
$script:Fail = 0
function Assert($label, $cond) {
    if ($cond) { $script:Pass++; Write-Host "PASS  $label" -ForegroundColor Green }
    else       { $script:Fail++; Write-Host "FAIL  $label" -ForegroundColor Red }
}
# Reads JSON if the file exists, else $null, so a missing file is a FAIL line
# and not a crash before the totals print.
function Read-JsonOrNull($path) {
    if (Test-Path $path) { return (Get-Content $path -Raw | ConvertFrom-Json) }
    return $null
}
function Read-TextOrEmpty($path) {
    if (Test-Path $path) { return [IO.File]::ReadAllText($path) }
    return ''
}

$PluginName = 'kw-doc-formats'

Write-Host '--- manifests ---'
$pluginJson = Join-Path $Root '.claude-plugin/plugin.json'
$mktJson    = Join-Path $Root '.claude-plugin/marketplace.json'
Assert 'plugin.json exists' (Test-Path $pluginJson)
Assert 'marketplace.json exists' (Test-Path $mktJson)
$plugin = Read-JsonOrNull $pluginJson
$mkt    = Read-JsonOrNull $mktJson

# kw_install writes this string into $script:Plugins; it is pinned here so the
# two repos cannot drift without one of them failing.
Assert "plugin.json name is $PluginName" ($plugin.name -eq $PluginName)
Assert "marketplace name is $PluginName" ($mkt.name -eq $PluginName)
Assert 'the marketplace lists exactly one plugin' ($null -ne $mkt -and @($mkt.plugins).Count -eq 1)
# Indexing $null (eg. $mkt.plugins[0] when marketplace.json is missing) is a
# terminating error in PowerShell 7, so the first entry is resolved through a
# guarded variable rather than indexed inline; a missing/empty list becomes a
# FAIL line below instead of crashing the script before the totals print.
$mktPlugin0 = $null
if ($mkt -and $mkt.plugins -and @($mkt.plugins).Count -gt 0) { $mktPlugin0 = @($mkt.plugins)[0] }
Assert "that plugin is $PluginName" ($null -ne $mktPlugin0 -and $mktPlugin0.name -eq $PluginName)
Assert 'the plugin source is the repo root' ($null -ne $mktPlugin0 -and $mktPlugin0.source -eq './')
Assert 'both descriptions are the same text' ($null -ne $plugin.description -and $null -ne $mktPlugin0 -and $plugin.description -eq $mktPlugin0.description)
Assert 'plugin.json carries no version (commit-based auto update)' ($null -ne $plugin -and $null -eq $plugin.PSObject.Properties['version'])

Write-Host '--- skills ---'
$skillDirs = @(Get-ChildItem -Path (Join-Path $Root 'skills') -Directory -ErrorAction SilentlyContinue)
Assert 'at least one skill ships' ($skillDirs.Count -gt 0)
foreach ($d in $skillDirs) {
    $md = Join-Path $d.FullName 'SKILL.md'
    Assert "$($d.Name) has SKILL.md" (Test-Path $md)
    $text = Read-TextOrEmpty $md
    $name = ([regex]::Match($text, '(?m)^name:\s*(\S+)\s*$')).Groups[1].Value
    Assert "$($d.Name) frontmatter name matches the folder" ($name -eq $d.Name)
}

# A skill is only read when its description matches what the user is doing.
# Deck and PDF guidance lives in document-formats, so both must be reachable.
$docFmt  = Read-TextOrEmpty (Join-Path $Root 'skills/document-formats/SKILL.md')
$docDesc = ([regex]::Match($docFmt, '(?ms)^description:\s*(.+?)$')).Groups[1].Value
foreach ($topic in @('pptx', 'PDF')) {
    Assert "the description mentions $topic" ($docDesc -match [regex]::Escape($topic))
}

# The Excel rule lives in this skill, so making a workbook must reach it too.
Assert 'the description mentions xlsx' ($docDesc -match 'xlsx')
Assert 'the body carries the Excel section' ($docFmt -match '(?m)^## 엑셀을 만들 때 항상 지킬 것')
Assert 'the Excel rule fixes the font size at 11' ($docFmt -match 'size=11')
Assert 'CSV meant for Excel is written with a BOM' ($docFmt -match 'utf-8-sig')

Write-Host '--- claude plugin validate ---'
# Exit code is the verdict. The tool prints warnings for a missing version and
# author and still exits 0; an error exits non-zero.
Push-Location $Root
try {
    $null = & claude plugin validate ./ 2>&1 | Out-String
    $code = $LASTEXITCODE
} finally { Pop-Location }
Assert 'claude plugin validate exits 0 (warnings allowed)' ($code -eq 0)

Write-Host ''
Write-Host ("PASS={0} FAIL={1}" -f $script:Pass, $script:Fail)
if ($script:Fail -ne 0) { exit 1 }
