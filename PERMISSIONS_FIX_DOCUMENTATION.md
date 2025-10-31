# WordPress Permissions Fix - Documentation

## Problem
WordPress Site Health was showing an error:
> "The wp-content/upgrade directory exists but is not writable. This directory is used for plugin and theme updates. Please make sure the server has write permissions to this directory."

## Root Cause
Several WordPress directories had the `ReadOnly` attribute set, which prevented WordPress from writing to them even though the Access Control List (ACL) permissions were correct.

## Affected Directories
- `wp-content/`
- `wp-content/plugins/`
- `wp-content/themes/`
- `wp-content/uploads/`
- `wp-content/upgrade/`
- `wp-content/mu-plugins/`

## Solution Applied
1. **Identified the Issue**: Used PowerShell commands to check directory attributes
2. **Removed ReadOnly Attributes**: Used `attrib -R` command to remove ReadOnly flags
3. **Verified Fix**: Created comprehensive tests to ensure all directories are writable
4. **Created Automation**: Built a PowerShell script for future use

## Commands Used
```powershell
# Check directory attributes
Get-ItemProperty "path\to\directory" | Select-Object FullName, Attributes

# Remove ReadOnly attribute
attrib -R "path\to\directory"

# Verify permissions
Test-Path "path\to\directory" -IsValid
```

## Files Created
- `test-upgrade-permissions.php` - Tests upgrade directory specifically
- `test-all-permissions.php` - Comprehensive WordPress filesystem test
- `fix-wordpress-permissions.ps1` - Automated fix script for future use

## Prevention
Run the PowerShell script `fix-wordpress-permissions.ps1` whenever:
- Setting up a new WordPress development environment
- After cloning the repository
- When seeing file permission errors in WordPress

## Verification Steps
1. Visit: `http://localhost:8000/wp-admin/site-health.php`
2. Check that no upgrade directory errors are shown
3. Try installing/updating a plugin to ensure it works

## Benefits
- ✅ WordPress can now perform plugin and theme updates
- ✅ File uploads work properly
- ✅ Site Health checks pass
- ✅ No more permission-related errors in WordPress admin