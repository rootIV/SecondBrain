param(
    [string]$VaultRoot = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path,
    [switch]$Json
)

$ErrorActionPreference = 'Stop'

function Get-MarkdownFiles {
    param([string]$Root)

    Get-ChildItem -LiteralPath $Root -Recurse -File -Filter '*.md' |
        Where-Object {
            $_.FullName -notmatch '\\.git\\' -and
            $_.FullName -notmatch '\\.obsidian\\plugins\\'
        } |
        Sort-Object FullName
}

function Get-WorkspaceBase {
    param(
        [string]$VaultRoot,
        [string]$WorkspacePath
    )

    $secondary = Join-Path $VaultRoot 'SecondBrain\.obsidian\workspace.json'
    if ($WorkspacePath -eq $secondary) {
        return (Join-Path $VaultRoot 'SecondBrain')
    }

    return $VaultRoot
}

$resolvedRoot = (Resolve-Path -LiteralPath $VaultRoot).Path
$markdownFiles = @(Get-MarkdownFiles -Root $resolvedRoot)

$emptyMarkdown = @($markdownFiles | Where-Object { $_.Length -eq 0 })
$doubleMdFiles = @(Get-ChildItem -LiteralPath $resolvedRoot -Recurse -File -Filter '*.md.md' |
    Where-Object { $_.FullName -notmatch '\\.git\\' -and $_.FullName -notmatch '\\.obsidian\\plugins\\' })

$noteNames = @{}
$duplicateNames = @{}
foreach ($file in $markdownFiles) {
    $name = [System.IO.Path]::GetFileNameWithoutExtension($file.Name)
    if ($noteNames.ContainsKey($name)) {
        if (-not $duplicateNames.ContainsKey($name)) {
            $duplicateNames[$name] = @($noteNames[$name])
        }
        $duplicateNames[$name] += $file.FullName
    }
    else {
        $noteNames[$name] = $file.FullName
    }
}

$wikiLinks = New-Object System.Collections.Generic.List[object]
foreach ($file in $markdownFiles) {
    $content = Get-Content -LiteralPath $file.FullName -Raw -Encoding UTF8
    if ($null -eq $content) {
        $content = ''
    }

    foreach ($match in [regex]::Matches($content, '\[\[([^\]|#]+)')) {
        $target = $match.Groups[1].Value.Trim()
        $wikiLinks.Add([pscustomobject]@{
            File = $file.FullName
            Target = $target
        })
    }
}

$brokenWikiLinks = @($wikiLinks |
    Where-Object { -not $noteNames.ContainsKey($_.Target) } |
    Sort-Object Target, File -Unique)

$workspaceFiles = @(
    Join-Path $resolvedRoot '.obsidian\workspace.json'
    Join-Path $resolvedRoot 'SecondBrain\.obsidian\workspace.json'
) | Where-Object { Test-Path -LiteralPath $_ }

$invalidWorkspaceJson = New-Object System.Collections.Generic.List[object]
$missingWorkspaceRefs = New-Object System.Collections.Generic.List[object]

foreach ($workspaceFile in $workspaceFiles) {
    try {
        $workspace = Get-Content -LiteralPath $workspaceFile -Raw -Encoding UTF8 | ConvertFrom-Json
    }
    catch {
        $invalidWorkspaceJson.Add([pscustomobject]@{
            Path = $workspaceFile
            Error = $_.Exception.Message
        })
        continue
    }

    $base = Get-WorkspaceBase -VaultRoot $resolvedRoot -WorkspacePath $workspaceFile
    foreach ($item in @($workspace.lastOpenFiles)) {
        if ([string]::IsNullOrWhiteSpace($item)) {
            continue
        }

        $candidate = Join-Path $base $item
        if (-not (Test-Path -LiteralPath $candidate)) {
            $missingWorkspaceRefs.Add([pscustomobject]@{
                Workspace = $workspaceFile
                Reference = $item
            })
        }
    }
}

$errorCount =
    $emptyMarkdown.Count +
    $doubleMdFiles.Count +
    $brokenWikiLinks.Count +
    $invalidWorkspaceJson.Count +
    $missingWorkspaceRefs.Count

$result = [pscustomobject]@{
    VaultRoot = $resolvedRoot
    MarkdownCount = $markdownFiles.Count
    EmptyMarkdown = $emptyMarkdown.Count
    DoubleMdFiles = $doubleMdFiles.Count
    WikiLinks = $wikiLinks.Count
    BrokenWikiLinks = $brokenWikiLinks.Count
    InvalidWorkspaceJson = $invalidWorkspaceJson.Count
    MissingWorkspaceRefs = $missingWorkspaceRefs.Count
    DuplicateNoteNames = $duplicateNames.Count
    Passed = ($errorCount -eq 0)
}

if ($Json) {
    $result | ConvertTo-Json -Depth 5
}
else {
    $result | Format-List

    if ($duplicateNames.Count -gt 0) {
        Write-Host ''
        Write-Host 'Warnings: duplicate note names can make wikilinks ambiguous.'
        foreach ($key in ($duplicateNames.Keys | Sort-Object)) {
            Write-Host "- $key"
            foreach ($path in $duplicateNames[$key]) {
                Write-Host "  $path"
            }
        }
    }

    if ($emptyMarkdown.Count -gt 0) {
        Write-Host ''
        Write-Host 'Empty markdown files:'
        $emptyMarkdown | Select-Object FullName, Length | Format-Table -AutoSize
    }

    if ($doubleMdFiles.Count -gt 0) {
        Write-Host ''
        Write-Host 'Files with .md.md extension:'
        $doubleMdFiles | Select-Object FullName, Length | Format-Table -AutoSize
    }

    if ($brokenWikiLinks.Count -gt 0) {
        Write-Host ''
        Write-Host 'Broken wikilinks:'
        $brokenWikiLinks | Format-Table -AutoSize
    }

    if ($invalidWorkspaceJson.Count -gt 0) {
        Write-Host ''
        Write-Host 'Invalid workspace JSON:'
        $invalidWorkspaceJson | Format-Table -AutoSize
    }

    if ($missingWorkspaceRefs.Count -gt 0) {
        Write-Host ''
        Write-Host 'Missing workspace references:'
        $missingWorkspaceRefs | Format-Table -AutoSize
    }
}

if (-not $result.Passed) {
    exit 1
}
