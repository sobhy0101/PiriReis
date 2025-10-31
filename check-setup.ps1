# WordPress Development Environment Status Checker

Write-Host ""
Write-Host "╔════════════════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║  WordPress Local Development Environment Check    ║" -ForegroundColor Cyan
Write-Host "╚════════════════════════════════════════════════════╝" -ForegroundColor Cyan
Write-Host ""

$allGood = $true

# Check PHP
Write-Host "🔍 Checking PHP..." -ForegroundColor Yellow
if (Get-Command php -ErrorAction SilentlyContinue) {
    $phpVersion = php -v 2>&1 | Select-Object -First 1
    Write-Host "   ✓ PHP is installed and accessible" -ForegroundColor Green
    Write-Host "   Version: $phpVersion" -ForegroundColor Gray
    
    # Check php.ini
    $phpIniPath = "C:\php\php.ini"
    if (Test-Path $phpIniPath) {
        Write-Host "   ✓ php.ini found at C:\php\php.ini" -ForegroundColor Green
    } else {
        Write-Host "   ✗ php.ini not found!" -ForegroundColor Red
        $allGood = $false
    }
    
    # Check extensions
    Write-Host "   Checking required extensions..." -ForegroundColor Gray
    $extensions = @("mysqli", "mbstring", "curl", "gd", "openssl", "zip")
    $loadedExtensions = php -m
    
    foreach ($ext in $extensions) {
        if ($loadedExtensions -contains $ext) {
            Write-Host "      ✓ $ext" -ForegroundColor Green
        } else {
            Write-Host "      ✗ $ext (not loaded)" -ForegroundColor Red
            $allGood = $false
        }
    }
} else {
    Write-Host "   ✗ PHP not found in PATH" -ForegroundColor Red
    Write-Host "   Run: C:\Projects\PiriReis\add-php-to-path.ps1 (as Admin)" -ForegroundColor Yellow
    $allGood = $false
}

Write-Host ""

# Check MySQL
Write-Host "🔍 Checking MySQL..." -ForegroundColor Yellow
$mysqlPaths = @(
    "C:\Program Files\MySQL\MySQL Server 8.0\bin\mysql.exe",
    "C:\Program Files\MySQL\MySQL Server 8.4\bin\mysql.exe",
    "C:\ProgramData\chocolatey\bin\mysql.exe",
    "C:\xampp\mysql\bin\mysql.exe"
)

$mysqlFound = $false
foreach ($path in $mysqlPaths) {
    if (Test-Path $path) {
        Write-Host "   ✓ MySQL found at: $path" -ForegroundColor Green
        $mysqlFound = $true
        break
    }
}

if (-not $mysqlFound) {
    Write-Host "   ✗ MySQL not found" -ForegroundColor Red
    Write-Host "   Install from: https://dev.mysql.com/downloads/installer/" -ForegroundColor Yellow
    $allGood = $false
}

# Check MySQL service
$mysqlService = Get-Service -Name "MySQL*" -ErrorAction SilentlyContinue
if ($mysqlService) {
    if ($mysqlService.Status -eq "Running") {
        Write-Host "   ✓ MySQL service is running" -ForegroundColor Green
    } else {
        Write-Host "   ⚠️  MySQL service is not running" -ForegroundColor Yellow
        Write-Host "   Start with: Start-Service $($mysqlService.Name)" -ForegroundColor Gray
    }
} else {
    if ($mysqlFound) {
        Write-Host "   ℹ️  MySQL service not found (might be XAMPP or manual installation)" -ForegroundColor Cyan
    }
}

Write-Host ""

# Check WordPress files
Write-Host "🔍 Checking WordPress..." -ForegroundColor Yellow
$websitePath = "C:\Projects\PiriReis\website"

if (Test-Path $websitePath) {
    Write-Host "   ✓ Website directory exists: $websitePath" -ForegroundColor Green
    
    $wpFiles = @("wp-config-sample.php", "wp-load.php", "wp-settings.php", "index.php")
    $wpInstalled = $true
    
    foreach ($file in $wpFiles) {
        if (-not (Test-Path (Join-Path $websitePath $file))) {
            $wpInstalled = $false
            break
        }
    }
    
    if ($wpInstalled) {
        Write-Host "   ✓ WordPress files detected" -ForegroundColor Green
        
        $wpConfigPath = Join-Path $websitePath "wp-config.php"
        if (Test-Path $wpConfigPath) {
            Write-Host "   ✓ wp-config.php exists" -ForegroundColor Green
        } else {
            Write-Host "   ⚠️  wp-config.php not configured yet" -ForegroundColor Yellow
            Write-Host "   Copy from wp-config-sample.php and configure database" -ForegroundColor Gray
        }
    } else {
        Write-Host "   ✗ WordPress not installed" -ForegroundColor Red
        Write-Host "   Run: C:\Projects\PiriReis\setup-wordpress.ps1" -ForegroundColor Yellow
        $allGood = $false
    }
} else {
    Write-Host "   ✗ Website directory not found" -ForegroundColor Red
    Write-Host "   Run: C:\Projects\PiriReis\setup-wordpress.ps1" -ForegroundColor Yellow
    $allGood = $false
}

Write-Host ""

# Check Git repository
Write-Host "🔍 Checking Git Repository..." -ForegroundColor Yellow
$gitPath = "C:\Projects\PiriReis\.git"

if (Test-Path $gitPath) {
    Write-Host "   ✓ Git repository initialized" -ForegroundColor Green
    
    $gitignorePath = "C:\Projects\PiriReis\.gitignore"
    if (Test-Path $gitignorePath) {
        Write-Host "   ✓ .gitignore exists" -ForegroundColor Green
    } else {
        Write-Host "   ⚠️  .gitignore not found" -ForegroundColor Yellow
    }
} else {
    Write-Host "   ℹ️  Not a Git repository yet" -ForegroundColor Cyan
    Write-Host "   Initialize with: cd C:\Projects\PiriReis && git init" -ForegroundColor Gray
}

Write-Host ""
Write-Host "════════════════════════════════════════════════════" -ForegroundColor Cyan

# Final summary
if ($allGood) {
    Write-Host ""
    Write-Host "🎉 All systems ready! You can start developing." -ForegroundColor Green
    Write-Host ""
    Write-Host "To start your WordPress site:" -ForegroundColor Yellow
    Write-Host "  cd C:\Projects\PiriReis\website" -ForegroundColor White
    Write-Host "  php -S localhost:8000" -ForegroundColor Cyan
    Write-Host "  Then visit: http://localhost:8000" -ForegroundColor White
} else {
    Write-Host ""
    Write-Host "⚠️  Some components need attention. See above for details." -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Setup Scripts Available:" -ForegroundColor Cyan
    Write-Host "  • C:\Projects\PiriReis\setup-wordpress.ps1 - Download WordPress" -ForegroundColor White
    Write-Host "  • C:\Projects\PiriReis\setup-mysql-database.ps1 - Setup database" -ForegroundColor White
    Write-Host "  • C:\Projects\PiriReis\add-php-to-path.ps1 - Add PHP to PATH (Admin)" -ForegroundColor White
}

Write-Host ""
Write-Host "📖 Full documentation: C:\Projects\PiriReis\WORDPRESS_SETUP_GUIDE.md" -ForegroundColor Cyan
Write-Host ""
