param()

$ErrorActionPreference = 'Stop'

$repoRoot = Split-Path -Parent $PSScriptRoot
$catalogPath = Join-Path $repoRoot 'mods\japanese-animal-names\catalog\name-catalog.toml'
$outputPath = Join-Path $repoRoot 'mods\japanese-animal-names\gml\JapaneseAnimalNames.gml'
$allowedCategories = @('pet_style', 'sweets', 'season_nature', 'flower_plant', 'color_inspired', 'vanilla_inspired')

function Get-TomlValue([string]$block, [string]$key) {
    $pattern = '(?m)^{0}\s*=\s*"(?<value>[^"]+)"\s*$' -f [regex]::Escape($key)
    $match = [regex]::Match($block, $pattern)
    if (-not $match.Success) { throw "Pool is missing $key." }
    return $match.Groups['value'].Value
}

function Get-TomlBool([string]$block, [string]$key) {
    $pattern = '(?m)^{0}\s*=\s*(?<value>true|false)\s*$' -f [regex]::Escape($key)
    $match = [regex]::Match($block, $pattern)
    if (-not $match.Success) { throw "Pool is missing boolean $key." }
    return [bool]::Parse($match.Groups['value'].Value)
}

function Get-TomlInt([string]$block, [string]$key) {
    $pattern = '(?m)^{0}\s*=\s*(?<value>\d+)\s*$' -f [regex]::Escape($key)
    $match = [regex]::Match($block, $pattern)
    if (-not $match.Success) { throw "Pool is missing integer $key." }
    return [int]$match.Groups['value'].Value
}

function Get-TomlNames([string]$block) {
    $match = [regex]::Match($block, '(?s)names\s*=\s*\[(?<value>.*?)\]')
    if (-not $match.Success) { throw 'Pool is missing names.' }
    return [regex]::Matches($match.Groups['value'].Value, '"(?<name>(?:\\.|[^"\\])*)"') |
        ForEach-Object { $_.Groups['name'].Value.Replace('\"', '"').Replace('\\', '\') }
}

function ConvertTo-GmlString([string]$value) {
    return '"' + $value.Replace('\', '\\').Replace('"', '\"') + '"'
}

$catalog = Get-Content -LiteralPath $catalogPath -Raw -Encoding utf8
$blocks = [regex]::Split($catalog, '(?m)^\[\[pool\]\]\s*$') | Select-Object -Skip 1
$groups = [ordered]@{}
$poolIds = [System.Collections.Generic.HashSet[int]]::new()

foreach ($block in $blocks) {
    $id = Get-TomlInt $block 'id'
    if (-not $poolIds.Add($id)) { throw "Duplicate pool id '$id'." }
    $source = Get-TomlValue $block 'source'
    if ($source -ne 'mod') { continue }

    $sex = Get-TomlValue $block 'sex'
    $category = Get-TomlValue $block 'category'
    $enabled = Get-TomlBool $block 'enabled_by_default'
    $names = @(Get-TomlNames $block)

    if ($sex -ne 'shared') { throw "MOD pool '$category' must use sex = shared." }
    if ($category -notin $allowedCategories) { throw "Unknown MOD category '$category'." }
    if (-not $enabled) { $names = @() }
    if ($groups.Contains($category)) { throw "Duplicate MOD category '$category'." }
    $groups[$category] = $names
}

foreach ($category in $allowedCategories) {
    if (-not $groups.Contains($category)) { throw "Missing MOD category '$category'." }
}

$lines = @(
    '// Generated from catalog/name-catalog.toml. Do not edit by hand.',
    '// Run tools/Build-JapaneseAnimalNamesCatalog.ps1 after editing the TOML.',
    ''
)
foreach ($category in $allowedCategories) {
    $lines += "function japanese_animal_names_$category() {"
    $lines += '    return ['
    $quoted = @($groups[$category] | ForEach-Object { '        ' + (ConvertTo-GmlString $_) })
    for ($index = 0; $index -lt $quoted.Count; $index++) {
        $suffix = if ($index -lt ($quoted.Count - 1)) { ',' } else { '' }
        $lines += $quoted[$index] + $suffix
    }
    $lines += '    ];'
    $lines += '}'
    $lines += ''
}

$generatedCatalog = ($lines -join "`r`n") + "`r`n"
$source = Get-Content -LiteralPath $outputPath -Raw -Encoding utf8
$startMarker = '// <generated-name-catalog>'
$endMarker = '// </generated-name-catalog>'
$start = $source.IndexOf($startMarker)
$end = $source.IndexOf($endMarker)
if ($start -lt 0 -or $end -lt 0 -or $end -lt $start) {
    throw "Could not find generated-name-catalog markers in $outputPath."
}

$before = $source.Substring(0, $start + $startMarker.Length)
$after = $source.Substring($end)
$updated = $before + "`r`n" + $generatedCatalog + $after
[System.IO.File]::WriteAllText($outputPath, $updated, [System.Text.UTF8Encoding]::new($false))
Write-Host "Generated name catalogue in $outputPath"
