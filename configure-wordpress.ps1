# Configure WordPress wp-config.php with Database Credentials
# This script updates wp-config.php with your database settings

Write-Host ""
Write-Host "╔════════════════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║     WordPress Configuration Script                ║" -ForegroundColor Cyan
Write-Host "╚════════════════════════════════════════════════════╝" -ForegroundColor Cyan
Write-Host ""

$wpConfigPath = "C:\Projects\PiriReis\website\wp-config.php"
$wpConfigSamplePath = "C:\Projects\PiriReis\website\wp-config-sample.php"
$credentialsPath = "C:\Projects\PiriReis\wordpress-db-credentials.txt"

# Check if credentials file exists
if (-not (Test-Path $credentialsPath)) {
    Write-Host "✗ Credentials file not found!" -ForegroundColor Red
    Write-Host "  Run: .\setup-mysql-database.ps1 first" -ForegroundColor Yellow
    exit 1
}

# Read credentials
$credentials = Get-Content $credentialsPath
$dbName = "wordpress_db"
$dbUser = "wp_user"
$dbPassword = "root"
$dbHost = "localhost"

Write-Host "📋 Database Credentials:" -ForegroundColor Yellow
Write-Host "   Database: $dbName" -ForegroundColor White
Write-Host "   User: $dbUser" -ForegroundColor White
Write-Host "   Password: $dbPassword" -ForegroundColor White
Write-Host "   Host: $dbHost" -ForegroundColor White
Write-Host ""

# Create wp-config.php from sample if it doesn't exist
if (-not (Test-Path $wpConfigPath)) {
    if (Test-Path $wpConfigSamplePath) {
        Copy-Item $wpConfigSamplePath $wpConfigPath -Force
        Write-Host "✓ Created wp-config.php from sample" -ForegroundColor Green
    } else {
        Write-Host "✗ wp-config-sample.php not found!" -ForegroundColor Red
        exit 1
    }
}

# Read the wp-config.php file
Write-Host "⚙️  Configuring wp-config.php..." -ForegroundColor Yellow
$wpConfig = Get-Content $wpConfigPath -Raw

# Update database settings
$wpConfig = $wpConfig -replace "define\(\s*'DB_NAME',\s*'[^']*'\s*\);", "define( 'DB_NAME', '$dbName' );"
$wpConfig = $wpConfig -replace "define\(\s*'DB_USER',\s*'[^']*'\s*\);", "define( 'DB_USER', '$dbUser' );"
$wpConfig = $wpConfig -replace "define\(\s*'DB_PASSWORD',\s*'[^']*'\s*\);", "define( 'DB_PASSWORD', '$dbPassword' );"
$wpConfig = $wpConfig -replace "define\(\s*'DB_HOST',\s*'[^']*'\s*\);", "define( 'DB_HOST', '$dbHost' );"

# Get security keys from WordPress API
Write-Host "🔐 Fetching security keys from WordPress..." -ForegroundColor Yellow
try {
    $securityKeys = Invoke-WebRequest -Uri "https://api.wordpress.org/secret-key/1.1/salt/" -UseBasicParsing
    $keys = $securityKeys.Content
    
    # Replace the placeholder keys section
    $pattern = "(?s)define\('AUTH_KEY'.*?define\('NONCE_SALT'[^;]+\);"
    if ($wpConfig -match $pattern) {
        $wpConfig = $wpConfig -replace $pattern, $keys.TrimEnd()
        Write-Host "✓ Security keys updated" -ForegroundColor Green
    } else {
        Write-Host "⚠️  Could not find security keys section to replace" -ForegroundColor Yellow
    }
} catch {
    Write-Host "⚠️  Could not fetch security keys automatically" -ForegroundColor Yellow
    Write-Host "   Get them manually from: https://api.wordpress.org/secret-key/1.1/salt/" -ForegroundColor Gray
}

# Add debugging configuration (commented out by default)
if ($wpConfig -notmatch "WP_DEBUG") {
    $debugConfig = @"


/* Debugging - Uncomment to enable */
// define( 'WP_DEBUG', true );
// define( 'WP_DEBUG_LOG', true );
// define( 'WP_DEBUG_DISPLAY', false );
// @ini_set( 'display_errors', 0 );

"@
    $wpConfig = $wpConfig -replace "(/\* That's all, stop editing!)", "$debugConfig`$1"
}

# Save the updated configuration
Set-Content -Path $wpConfigPath -Value $wpConfig -NoNewline
Write-Host "✓ Database credentials configured" -ForegroundColor Green
Write-Host ""

# Verify configuration
Write-Host "🔍 Verifying configuration..." -ForegroundColor Yellow
$testConfig = Get-Content $wpConfigPath -Raw

$checks = @(
    @{ Pattern = "DB_NAME.*wordpress_db"; Message = "Database name" },
    @{ Pattern = "DB_USER.*wp_user"; Message = "Database user" },
    @{ Pattern = "DB_PASSWORD.*$dbPassword"; Message = "Database password" },
    @{ Pattern = "DB_HOST.*localhost"; Message = "Database host" }
)

$allGood = $true
foreach ($check in $checks) {
    if ($testConfig -match $check.Pattern) {
        Write-Host "   ✓ $($check.Message)" -ForegroundColor Green
    } else {
        Write-Host "   ✗ $($check.Message)" -ForegroundColor Red
        $allGood = $false
    }
}

Write-Host ""

if ($allGood) {
    Write-Host "════════════════════════════════════════════════════" -ForegroundColor Cyan
    Write-Host "✅ WordPress Configuration Complete!" -ForegroundColor Green
    Write-Host "════════════════════════════════════════════════════" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "🚀 Next Steps:" -ForegroundColor Yellow
    Write-Host "   1. Start the PHP development server:" -ForegroundColor White
    Write-Host "      cd C:\Projects\PiriReis\website" -ForegroundColor Cyan
    Write-Host "      php -S localhost:8000" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "   2. Open your browser to:" -ForegroundColor White
    Write-Host "      http://localhost:8000" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "   3. Complete the WordPress installation wizard" -ForegroundColor White
    Write-Host ""
} else {
    Write-Host "⚠️  Some configuration checks failed." -ForegroundColor Yellow
    Write-Host "   Please manually verify wp-config.php" -ForegroundColor White
    Write-Host ""
}
