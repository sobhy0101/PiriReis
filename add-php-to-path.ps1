# Add PHP to System PATH - Run as Administrator
# Right-click PowerShell and select "Run as Administrator", then run this script

$phpPath = "C:\php"
$currentPath = [System.Environment]::GetEnvironmentVariable('Path', 'Machine')

if ($currentPath -notlike "*$phpPath*") {
    $newPath = $currentPath + ";$phpPath"
    [System.Environment]::SetEnvironmentVariable('Path', $newPath, 'Machine')
    Write-Host "✓ PHP has been added to system PATH successfully!" -ForegroundColor Green
    Write-Host "  Please restart your terminal for changes to take effect." -ForegroundColor Yellow
} else {
    Write-Host "✓ PHP is already in system PATH" -ForegroundColor Green
}

# Verify PHP installation
Write-Host "`nTesting PHP installation..."
& "C:\php\php.exe" -v
