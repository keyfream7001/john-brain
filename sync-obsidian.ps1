# sync-obsidian.ps1
# publish: true 가 frontmatter에 있는 노트만 Quartz content 폴더로 동기화

$VaultPath = "C:\Users\phase\Documents\Obsidian\John's Brain"
$ContentPath = "$PSScriptRoot\content"

Write-Host "Syncing publish:true notes to Quartz..." -ForegroundColor Cyan

# 기존 content 초기화 (index.md 제외)
Get-ChildItem -Path $ContentPath -Recurse -File |
    Where-Object { $_.Name -ne "index.md" } |
    Remove-Item -Force -ErrorAction SilentlyContinue

Get-ChildItem -Path $ContentPath -Directory |
    Where-Object { $_.GetFiles("*", "AllDirectories").Count -eq 0 } |
    Remove-Item -Recurse -Force -ErrorAction SilentlyContinue

$ExcludeDirs = @('.obsidian', '.trash', 'private', 'archive')
$published = 0
$skipped = 0

Get-ChildItem -Path $VaultPath -Recurse -Filter "*.md" | Where-Object {
    $item = $_
    $isExcluded = $false
    foreach ($excDir in $ExcludeDirs) {
        if ($item.FullName -like "*\$excDir\*") { $isExcluded = $true; break }
    }
    -not $isExcluded
} | ForEach-Object {
    $content = [System.IO.File]::ReadAllText($_.FullName, [System.Text.Encoding]::UTF8)
    $hasPublish = $false
    # frontmatter에서만 publish: true 확인
    if ($content -match "(?s)^---\r?\n(.*?)\r?\n---") {
        $fm = $Matches[1]
        if ($fm -match "(?m)^publish:\s*true") {
            $hasPublish = $true
        }
    }
    if ($hasPublish) {
        $relativePath = $_.FullName.Substring($VaultPath.Length + 1)
        $destPath = Join-Path $ContentPath $relativePath
        $destDir = Split-Path $destPath -Parent
        New-Item -ItemType Directory -Path $destDir -Force | Out-Null
        Copy-Item -Path $_.FullName -Destination $destPath -Force
        $published++
        Write-Host "  + $($_.Name)" -ForegroundColor Green
    } else {
        $skipped++
    }
}

$imgExts = @('.png', '.jpg', '.jpeg', '.gif', '.svg', '.webp', '.pdf')
Get-ChildItem -Path $VaultPath -Recurse -File | Where-Object {
    $imgExts -contains $_.Extension.ToLower()
} | ForEach-Object {
    $relativePath = $_.FullName.Substring($VaultPath.Length + 1)
    $destPath = Join-Path $ContentPath $relativePath
    $destDir = Split-Path $destPath -Parent
    if (Test-Path $destDir) {
        Copy-Item -Path $_.FullName -Destination $destPath -Force -ErrorAction SilentlyContinue
    }
}

Write-Host ""
Write-Host "Done! Published: $published notes | Skipped: $skipped notes" -ForegroundColor Green
Write-Host ""
Write-Host "Next: git add -A && git commit -m 'update' && git push" -ForegroundColor Yellow