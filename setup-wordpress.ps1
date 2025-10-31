# WordPress Download and Setup Script
# Run this script from PowerShell in C:\Projects\PiriReis

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  WordPress Local Development Setup" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

$websitePath = "C:\Projects\PiriReis\website"
$downloadPath = "C:\Projects\PiriReis"

# Create website directory
Write-Host "📁 Creating website directory..." -ForegroundColor Yellow
if (-not (Test-Path $websitePath)) {
    New-Item -ItemType Directory -Force -Path $websitePath | Out-Null
    Write-Host "   ✓ Created: $websitePath" -ForegroundColor Green
} else {
    Write-Host "   ✓ Directory already exists: $websitePath" -ForegroundColor Green
}

# Download WordPress
Write-Host ""
Write-Host "⬇️  Downloading WordPress..." -ForegroundColor Yellow
$wpZip = Join-Path $downloadPath "wordpress.zip"

try {
    Invoke-WebRequest -Uri "https://wordpress.org/latest.zip" -OutFile $wpZip -UseBasicParsing
    Write-Host "   ✓ WordPress downloaded successfully!" -ForegroundColor Green
} catch {
    Write-Host "   ✗ Error downloading WordPress: $_" -ForegroundColor Red
    exit 1
}

# Extract WordPress
Write-Host ""
Write-Host "📦 Extracting WordPress..." -ForegroundColor Yellow
$tempWpPath = Join-Path $downloadPath "wordpress"

try {
    Expand-Archive -Path $wpZip -DestinationPath $downloadPath -Force
    Write-Host "   ✓ WordPress extracted successfully!" -ForegroundColor Green
} catch {
    Write-Host "   ✗ Error extracting WordPress: $_" -ForegroundColor Red
    exit 1
}

# Move WordPress files to website directory
Write-Host ""
Write-Host "📋 Moving WordPress files..." -ForegroundColor Yellow

try {
    Get-ChildItem -Path $tempWpPath -Recurse | Move-Item -Destination $websitePath -Force
    Write-Host "   ✓ WordPress files moved to $websitePath" -ForegroundColor Green
} catch {
    Write-Host "   ✗ Error moving files: $_" -ForegroundColor Red
    exit 1
}

# Clean up
Write-Host ""
Write-Host "🧹 Cleaning up..." -ForegroundColor Yellow
Remove-Item $wpZip -Force
Remove-Item $tempWpPath -Recurse -Force
Write-Host "   ✓ Cleanup complete!" -ForegroundColor Green

# Create wp-config.php from sample
Write-Host ""
Write-Host "⚙️  Setting up wp-config.php..." -ForegroundColor Yellow
$wpConfigSample = Join-Path $websitePath "wp-config-sample.php"
$wpConfig = Join-Path $websitePath "wp-config.php"

if (Test-Path $wpConfigSample) {
    Copy-Item $wpConfigSample $wpConfig -Force
    Write-Host "   ✓ wp-config.php created from sample" -ForegroundColor Green
    Write-Host "   ⚠️  Remember to edit wp-config.php with your database credentials!" -ForegroundColor Yellow
} else {
    Write-Host "   ✗ wp-config-sample.php not found!" -ForegroundColor Red
}

# Create .gitignore for WordPress
Write-Host ""
Write-Host "📝 Creating .gitignore..." -ForegroundColor Yellow
$gitignorePath = Join-Path $downloadPath ".gitignore"
$gitignoreContent = @"
# WordPress specific
wp-config.php
.htaccess

# Uploads
website/wp-content/uploads/
website/wp-content/upgrade/
website/wp-content/cache/

# Log files
*.log
website/wp-content/debug.log

# Database backups
*.sql
*.sql.gz

# OS files
.DS_Store
Thumbs.db

# IDE files
.vscode/
.idea/
*.sublime-project
*.sublime-workspace

# Environment files
.env
.env.local
"@

Set-Content -Path $gitignorePath -Value $gitignoreContent
Write-Host "   ✓ .gitignore created" -ForegroundColor Green

# Summary
Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  ✅ WordPress Setup Complete!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "📍 WordPress Location: $websitePath" -ForegroundColor White
Write-Host ""
Write-Host "🔧 Next Steps:" -ForegroundColor Yellow
Write-Host "  1. Install MySQL and create database" -ForegroundColor White
Write-Host "  2. Edit wp-config.php with database credentials" -ForegroundColor White
Write-Host "  3. Get security keys: https://api.wordpress.org/secret-key/1.1/salt/" -ForegroundColor White
Write-Host "  4. Start PHP server: cd $websitePath && php -S localhost:8000" -ForegroundColor White
Write-Host "  5. Visit http://localhost:8000 in your browser" -ForegroundColor White
Write-Host ""
Write-Host "📖 Full guide: $downloadPath\WORDPRESS_SETUP_GUIDE.md" -ForegroundColor Cyan
Write-Host ""
