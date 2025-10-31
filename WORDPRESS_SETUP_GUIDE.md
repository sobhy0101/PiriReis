# WordPress Local Development Setup Guide

## Project Information

- **Development Path**: C:\Projects\PiriReis\website
- **Git Repository**: C:\Projects\PiriReis\
- **PHP Location**: C:\php

---

## ✅ Completed Steps

### 1. PHP Configuration (DONE)

- ✓ Enabled required extensions: mysqli, mbstring, curl, fileinfo, gd, intl, openssl, pdo_mysql, zip, opcache
- ✓ Set extension_dir = "ext"
- ✓ Increased memory_limit to 256M
- ✓ Increased post_max_size to 64M
- ✓ Increased upload_max_filesize to 64M
- ✓ Set timezone to UTC

### 2. PHP PATH (IN PROGRESS)

- ✓ PHP is accessible in current terminal session
- ⚠ To add permanently, run `C:\Projects\PiriReis\add-php-to-path.ps1` as Administrator

---

## 📋 Remaining Steps

### 3. Install MySQL

#### Option A: MySQL Installer (Recommended)

1. Download MySQL Installer from: <https://dev.mysql.com/downloads/installer/>
   - Choose "mysql-installer-community-8.x.x.msi"
2. Run the installer and select "Custom" installation
3. Select these components:
   - MySQL Server 8.x
   - MySQL Workbench (optional GUI tool)
4. During configuration:
   - **Root Password**: Create a strong password (save it!)
   - **Port**: Keep default 3306
   - **Windows Service**: Enable "Start MySQL at System Startup"
5. Complete the installation

#### Option B: Chocolatey (Command-line)

```powershell
choco install mysql
```

#### Create WordPress Database

After MySQL installation, create the database:

```sql
# Open MySQL command line or MySQL Workbench
mysql -u root -p

# Enter your root password, then run:
CREATE DATABASE wordpress_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE USER 'wp_user'@'localhost' IDENTIFIED BY 'your_secure_password';
GRANT ALL PRIVILEGES ON wordpress_db.* TO 'wp_user'@'localhost';
FLUSH PRIVILEGES;
EXIT;
```

**Save these credentials:**

- Database Name: `wordpress_db`
- Username: `wp_user`
- Password: `your_secure_password`
- Host: `localhost`

### 4. Download & Install WordPress

```powershell
# Navigate to your project directory
cd C:\Projects\PiriReis

# Create website directory if it doesn't exist
New-Item -ItemType Directory -Force -Path "C:\Projects\PiriReis\website"

# Download WordPress
Invoke-WebRequest -Uri "https://wordpress.org/latest.zip" -OutFile "wordpress.zip"

# Extract WordPress
Expand-Archive -Path "wordpress.zip" -DestinationPath "C:\Projects\PiriReis" -Force

# Move WordPress files to website directory
Move-Item -Path "C:\Projects\PiriReis\wordpress\*" -Destination "C:\Projects\PiriReis\website" -Force

# Clean up
Remove-Item "wordpress.zip"
Remove-Item "C:\Projects\PiriReis\wordpress" -Recurse
```

### 5. Configure WordPress

```powershell
cd C:\Projects\PiriReis\website

# Copy sample config to create wp-config.php
Copy-Item "wp-config-sample.php" "wp-config.php"
```

Then edit `wp-config.php` with your database credentials:

```php
define( 'DB_NAME', 'wordpress_db' );
define( 'DB_USER', 'wp_user' );
define( 'DB_PASSWORD', 'your_secure_password' );
define( 'DB_HOST', 'localhost' );
```

Get security keys from: <https://api.wordpress.org/secret-key/1.1/salt/>
Replace the placeholder keys in wp-config.php

### 6. Start Development Server

#### Option A: PHP Built-in Server (Simple, Good for Development)

```powershell
cd C:\Projects\PiriReis\website
php -S localhost:8000
```

Access at: <http://localhost:8000>

#### Option B: XAMPP (Full Apache/MySQL/PHP Stack)

1. Download from: <https://www.apachefriends.org/>
2. Install to C:\xampp
3. Copy WordPress files to C:\xampp\htdocs\website
4. Start Apache and MySQL from XAMPP Control Panel
5. Access at: <http://localhost/website>

#### Option C: Local by Flywheel (WordPress-Specific, Easiest)

1. Download from: <https://localwp.com/>
2. Install and create new site
3. Import your WordPress files

### 7. Complete WordPress Installation

1. Open browser to your local URL (e.g., <http://localhost:8000>)
2. Follow WordPress installation wizard:
   - Site Title
   - Admin Username
   - Admin Password
   - Admin Email
3. Click "Install WordPress"
4. Log in and start developing!

---

## 🔧 Useful Commands

### Check PHP Version

```powershell
php -v
```

### Check PHP Extensions

```powershell
php -m
```

### Check MySQL Service Status

```powershell
Get-Service MySQL*
```

### Start MySQL Service

```powershell
Start-Service MySQL80
```

### Git Commands for Your Project

```powershell
cd C:\Projects\PiriReis
git status
git add .
git commit -m "Initial WordPress setup"
git push
```

---

## 📝 Notes

- Keep `wp-config.php` out of version control (add to .gitignore)
- WordPress files can be large - consider adding `/website/wp-content/uploads/` to .gitignore
- Use a `.env` file for sensitive credentials in production
- Test thoroughly before deploying to production

---

## 🆘 Troubleshooting

### PHP Extensions Not Loading

- Verify `extension_dir = "ext"` in php.ini
- Check that C:\php\ext folder exists with DLL files

### Can't Connect to MySQL

- Verify MySQL service is running: `Get-Service MySQL*`
- Check credentials in wp-config.php
- Ensure MySQL is listening on port 3306

### WordPress White Screen

- Enable debugging in wp-config.php:

  ```php
  define( 'WP_DEBUG', true );
  define( 'WP_DEBUG_LOG', true );
  define( 'WP_DEBUG_DISPLAY', false );
  ```

- Check C:\Projects\PiriReis\website\wp-content\debug.log

### Permission Issues

- Right-click PowerShell and "Run as Administrator"
- Ensure write permissions on website folder

---

## 📚 Resources

- WordPress Documentation: <https://wordpress.org/documentation/>
- PHP Manual: <https://www.php.net/manual/en/>
- MySQL Documentation: <https://dev.mysql.com/doc/>
