# Comprehensive script to fix all remaining package:echat/ imports

$rootPath = "c:\my projects\all-in-one-agricaltural-app\lib"

# Get all Dart files recursively
$allFiles = Get-ChildItem -Path $rootPath -Filter "*.dart" -Recurse -ErrorAction SilentlyContinue

$fixedCount = 0
$totalCount = 0

Write-Host "Scanning for files with package:echat/ imports..."

foreach ($file in $allFiles) {
    try {
        $content = Get-Content $file.FullName -Raw -ErrorAction Stop
        
        if ($content -match 'package:echat/') {
            $totalCount++
            $newContent = $content -replace 'package:echat/', 'package:linkedfarm/'
            
            # Only write if content actually changed
            if ($newContent -ne $content) {
                Set-Content -Path $file.FullName -Value $newContent -NoNewline -ErrorAction Stop
                $fixedCount++
                $relativePath = $file.FullName.Replace($rootPath, "lib")
                Write-Host "✓ Fixed: $relativePath"
            }
        }
    }
    catch {
        Write-Host "✗ Error processing $($file.FullName): $_" -ForegroundColor Red
    }
}

Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "Summary:" -ForegroundColor Cyan
Write-Host "  Files scanned: $($allFiles.Count)" -ForegroundColor Yellow
Write-Host "  Files with echat imports: $totalCount" -ForegroundColor Yellow
Write-Host "  Files fixed: $fixedCount" -ForegroundColor Green
Write-Host "========================================`n" -ForegroundColor Cyan

if ($fixedCount -gt 0) {
    Write-Host "✓ All imports have been updated successfully!" -ForegroundColor Green
} else {
    Write-Host "No files needed fixing." -ForegroundColor Yellow
}
