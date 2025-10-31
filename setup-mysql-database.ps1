# MySQL Installation and Database Setup Helper
# Run this script AFTER installing MySQL

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  MySQL Database Setup for WordPress" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Check if MySQL is installed
$mysqlPath = $null
$possiblePaths = @(
    "C:\Program Files\MySQL\MySQL Server 8.0\bin\mysql.exe",
    "C:\Program Files\MySQL\MySQL Server 8.4\bin\mysql.exe",
    "C:\ProgramData\chocolatey\bin\mysql.exe",
    "C:\xampp\mysql\bin\mysql.exe"
)

foreach ($path in $possiblePaths) {
    if (Test-Path $path) {
        $mysqlPath = $path
        break
    }
}

if ($null -eq $mysqlPath) {
    Write-Host "⚠️  MySQL not found in common installation paths." -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Please install MySQL first:" -ForegroundColor White
    Write-Host "  Option 1: Download from https://dev.mysql.com/downloads/installer/" -ForegroundColor Cyan
    Write-Host "  Option 2: Install via Chocolatey: choco install mysql" -ForegroundColor Cyan
    Write-Host ""
    exit 1
}

Write-Host "✓ MySQL found at: $mysqlPath" -ForegroundColor Green
Write-Host ""

# Database credentials
$dbName = "wordpress_db"
$dbUser = "wp_user"
$dbPassword = Read-Host "Enter password for WordPress database user (wp_user)" -AsSecureString
$dbPasswordPlain = [Runtime.InteropServices.Marshal]::PtrToStringAuto(
    [Runtime.InteropServices.Marshal]::SecureStringToBSTR($dbPassword))

Write-Host ""
Write-Host "Creating MySQL commands..." -ForegroundColor Yellow

# Create SQL commands file
$sqlCommands = @"
-- Create WordPress database
CREATE DATABASE IF NOT EXISTS $dbName CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- Create WordPress user
CREATE USER IF NOT EXISTS '$dbUser'@'localhost' IDENTIFIED BY '$dbPasswordPlain';

-- Grant privileges
GRANT ALL PRIVILEGES ON $dbName.* TO '$dbUser'@'localhost';

-- Flush privileges
FLUSH PRIVILEGES;

-- Show databases
SHOW DATABASES;
"@

$sqlFile = "C:\Projects\PiriReis\create-wordpress-db.sql"
Set-Content -Path $sqlFile -Value $sqlCommands

Write-Host "✓ SQL commands file created: $sqlFile" -ForegroundColor Green
Write-Host ""

# Save credentials for reference
$credentialsFile = "C:\Projects\PiriReis\wordpress-db-credentials.txt"
$credentialsContent = @"
WordPress Database Credentials
================================
Database Name: $dbName
Username: $dbUser
Password: $dbPasswordPlain
Host: localhost
Port: 3306

⚠️  IMPORTANT: Keep this file secure! Do not commit to Git!

Use these credentials in your wp-config.php file:
define( 'DB_NAME', '$dbName' );
define( 'DB_USER', '$dbUser' );
define( 'DB_PASSWORD', '$dbPasswordPlain' );
define( 'DB_HOST', 'localhost' );
"@

Set-Content -Path $credentialsFile -Value $credentialsContent
Write-Host "✓ Credentials saved to: $credentialsFile" -ForegroundColor Green
Write-Host ""

# Instructions
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Next Steps" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "To create the database, run MySQL command line:" -ForegroundColor Yellow
Write-Host ""
Write-Host "  cd C:\Projects\PiriReis" -ForegroundColor White
Write-Host "  Get-Content create-wordpress-db.sql | mysql -u root -p" -ForegroundColor Cyan
Write-Host ""
Write-Host "Or manually:" -ForegroundColor Yellow
Write-Host "  1. Open MySQL Command Line Client or MySQL Workbench" -ForegroundColor White
Write-Host "  2. Enter your MySQL root password" -ForegroundColor White
Write-Host "  3. Copy and paste the contents of create-wordpress-db.sql" -ForegroundColor White
Write-Host ""
Write-Host "Database Details:" -ForegroundColor Yellow
Write-Host "  Database: $dbName" -ForegroundColor White
Write-Host "  User: $dbUser" -ForegroundColor White
Write-Host "  Password: [saved in wordpress-db-credentials.txt]" -ForegroundColor White
Write-Host ""
