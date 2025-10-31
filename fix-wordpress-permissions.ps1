# WordPress Permissions Fix Script
# Ensures all WordPress directories have proper write permissions for local development

Write-Host "WordPress Permissions Fix Script" -ForegroundColor Green
Write-Host "=================================" -ForegroundColor Green
Write-Host ""

$websiteDir = "C:\Projects\PiriReis\website"

# Check if WordPress directory exists
if (-not (Test-Path $websiteDir)) {
    Write-Host "WordPress directory not found: $websiteDir" -ForegroundColor Red
    exit 1
}

Write-Host "WordPress directory found: $websiteDir" -ForegroundColor Green

# Critical WordPress directories that need write permissions
$criticalDirs = @(
    "wp-content",
    "wp-content\plugins", 
    "wp-content\themes",
    "wp-content\uploads",
    "wp-content\upgrade",
    "wp-content\mu-plugins"
)

$fixedCount = 0
$totalChecked = 0

foreach ($dir in $criticalDirs) {
    $fullPath = "$websiteDir\$dir"
    $totalChecked++
    
    Write-Host "Checking: $dir" -ForegroundColor Cyan
    
    # Create directory if it doesn't exist
    if (-not (Test-Path $fullPath)) {
        New-Item -Path $fullPath -ItemType Directory -Force | Out-Null
        Write-Host "  Created missing directory" -ForegroundColor Green
    }
    
    # Check current attributes
    $item = Get-ItemProperty $fullPath
    $currentAttribs = $item.Attributes
    
    if ($currentAttribs -match "ReadOnly") {
        Write-Host "  ReadOnly attribute detected - fixing..." -ForegroundColor Yellow
        
        # Remove ReadOnly attribute
        attrib -R "$fullPath"
        Write-Host "  ReadOnly attribute removed" -ForegroundColor Green
        $fixedCount++
    } else {
        Write-Host "  Permissions already correct" -ForegroundColor Green
    }
    
    # Test write access
    $testFile = "$fullPath\permission-test-123.tmp"
    "test" | Out-File -FilePath $testFile -Force -ErrorAction SilentlyContinue
    if (Test-Path $testFile) {
        Remove-Item $testFile -Force -ErrorAction SilentlyContinue
        Write-Host "  Write test successful" -ForegroundColor Green
    } else {
        Write-Host "  Write test failed" -ForegroundColor Red
    }
}

Write-Host ""
Write-Host "Summary" -ForegroundColor Yellow
Write-Host "=======" -ForegroundColor Yellow
Write-Host "Directories checked: $totalChecked"
Write-Host "Permissions fixed: $fixedCount"

if ($fixedCount -gt 0) {
    Write-Host ""
    Write-Host "SUCCESS: Permissions have been fixed!" -ForegroundColor Green
    Write-Host "WordPress should now be able to perform updates properly." -ForegroundColor Green
} else {
    Write-Host ""
    Write-Host "SUCCESS: All permissions were already correct!" -ForegroundColor Green
}

Write-Host ""
Write-Host "To verify the fix worked:" -ForegroundColor Cyan
Write-Host "  1. Visit: http://localhost:8000/wp-admin/site-health.php" -ForegroundColor White
Write-Host "  2. Look for the upgrade directory error - it should be gone!" -ForegroundColor White
Write-Host ""
Write-Host "You can now install/update plugins and themes without issues!" -ForegroundColor Green