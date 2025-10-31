# PiriReis WordPress Development Environment

## Project Overview
Local WordPress development environment with automated PowerShell setup scripts. Runs WordPress 6.x with PHP 8.4+ and MySQL 8.0 on Windows using built-in PHP server (not Apache/IIS).

## Architecture & Key Components

### Development Server Pattern
- **Server**: PHP built-in server (`php -S localhost:8000`)
- **Document Root**: `website/` directory (not typical `public/` or `htdocs/`)
- **Database**: Local MySQL with custom credentials (`wp_user`/`wordpress_db`)

### Automation Scripts (PowerShell-First)
All setup is PowerShell-driven with specific execution order:
1. `setup-wordpress.ps1` - Downloads WordPress to `website/`
2. `setup-mysql-database.ps1` - Creates DB and user
3. `configure-wordpress.ps1` - Auto-generates `wp-config.php`
4. `check-setup.ps1` - Environment validation

### WordPress Configuration
- **DB Name**: `wordpress_db` (not `wordpress`)
- **DB User**: `wp_user` (not `root`)  
- **Custom Path**: PHP at `C:\php\` with specific `php.ini` settings
- **Extensions Required**: mysqli, mbstring, curl, fileinfo, gd, intl, openssl, pdo_mysql, zip, opcache

## Development Workflows

### Daily Development
```powershell
cd C:\Projects\PiriReis\website
php -S localhost:8000
```
Access: http://localhost:8000 (frontend) | http://localhost:8000/wp-admin (admin)

### Environment Troubleshooting
```powershell
.\check-setup.ps1  # Validates PHP, MySQL, extensions, file permissions
```

### Database Operations
```powershell
Get-Service MySQL80    # Check MySQL service status
Start-Service MySQL80  # Start if stopped
```

## Project-Specific Conventions

### File Organization
- `docs/` - Contains prompt engineering guides for AI interactions
- `website/` - WordPress installation root (not standard naming)
- Root PowerShell scripts - Setup automation (not in `scripts/` folder)
- `wordpress-db-credentials.txt` - Gitignored credentials file

### WordPress Customizations
- **Theme**: Uses `hello-biz` custom theme (not default themes)
- **Plugins**: Elementor Pro installed by default
- **Security**: Database credentials stored separately from wp-config template

### PowerShell Script Patterns
- All scripts use colored output with emojis for status
- Error handling with `$allGood` boolean pattern
- Path detection logic for MySQL in multiple common locations
- Credential input via `Read-Host -AsSecureString`

## Integration Points

### MySQL Service Dependencies
Scripts check multiple MySQL installation paths:
- `C:\Program Files\MySQL\MySQL Server 8.0\bin\mysql.exe`
- `C:\Program Files\MySQL\MySQL Server 8.4\bin\mysql.exe`
- `C:\ProgramData\chocolatey\bin\mysql.exe`
- `C:\xampp\mysql\bin\mysql.exe`

### WordPress File Structure
- Core WP files in `website/` root
- Custom content in `website/wp-content/`
- Configuration auto-generated, not manually edited
- Database credentials externalized to separate file

## Common Gotchas

1. **PHP Server Context**: Uses PHP built-in server, not full web server (affects .htaccess behavior)
2. **Windows Paths**: All scripts use Windows-specific paths (`C:\Projects\PiriReis\`)
3. **PowerShell Execution Policy**: Scripts may require `Set-ExecutionPolicy RemoteSigned`
4. **MySQL Service**: Must be running before database setup scripts
5. **Path Dependencies**: PHP must be in system PATH for daily workflow commands

## Reference Files
- `DAILY_REFERENCE.md` - Quick command reference for daily development
- `QUICK_START.md` - Setup process overview
- `docs/prompt-engineering-guide.md` - AI interaction patterns for this project