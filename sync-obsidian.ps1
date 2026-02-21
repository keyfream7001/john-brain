# sync-obsidian.ps1
# 옵시디언 볼트 → Quartz content 폴더 동기화 스크립트

$VaultPath = "C:\Users\phase\Documents\Obsidian\John's Brain"
$ContentPath = "$PSScriptRoot\content"

Write-Host "🌸 옵시디언 → Quartz 동기화 시작..." -ForegroundColor Cyan

# 기존 content 제거 후 새로 복사
Remove-Item -Recurse -Force "$ContentPath\*" -ErrorAction SilentlyContinue

# 복사 (제외 목록: .obsidian, 이미지/첨부 대용량 폴더 등)
$ExcludeDirs = @('.obsidian', '.trash', 'private', 'archive')
$ExcludeExts = @('*.pptx', '*.docx', '*.xlsx', '*.zip', '*.mp4', '*.mov')

Get-ChildItem -Path $VaultPath -Recurse | Where-Object {
    $item = $_
    $isExcludedDir = $false
    foreach ($excDir in $ExcludeDirs) {
        if ($item.FullName -like "*\$excDir\*" -or $item.Name -eq $excDir) {
            $isExcludedDir = $true
            break
        }
    }
    $isExcludedExt = $false
    foreach ($excExt in $ExcludeExts) {
        if ($item.Name -like $excExt) {
            $isExcludedExt = $true
            break
        }
    }
    -not $isExcludedDir -and -not $isExcludedExt -and -not $item.PSIsContainer
} | ForEach-Object {
    $relativePath = $_.FullName.Substring($VaultPath.Length + 1)
    $destPath = Join-Path $ContentPath $relativePath
    $destDir = Split-Path $destPath -Parent
    New-Item -ItemType Directory -Path $destDir -Force | Out-Null
    Copy-Item -Path $_.FullName -Destination $destPath -Force
}

$noteCount = (Get-ChildItem -Path $ContentPath -Filter "*.md" -Recurse).Count
Write-Host "✅ 동기화 완료! 마크다운 파일: $noteCount 개" -ForegroundColor Green
Write-Host ""
Write-Host "다음 단계: npx quartz sync" -ForegroundColor Yellow
