# 🎯 WordPress Development - Daily Reference Card

## Quick Start (Daily Use)

### Start WordPress Development Server

```powershell
cd C:\Projects\PiriReis\website
php -S localhost:8000
```

### Access Your Site

- **Frontend**: <http://localhost:8000>
- **Admin**: <http://localhost:8000/wp-admin>

### Stop Server

Press `Ctrl+C` in terminal

---

## Useful Commands

### Check Everything is Working

```powershell
cd C:\Projects\PiriReis
.\check-setup.ps1
```

### MySQL Service

```powershell
Get-Service MySQL80           # Check status
Start-Service MySQL80         # Start MySQL
Stop-Service MySQL80          # Stop MySQL
```

### PHP Info

```powershell
php -v                        # Version
php -m                        # Extensions
```

---

## Important Files

- **WordPress**: `C:\Projects\PiriReis\website\`
- **Config**: `C:\Projects\PiriReis\website\wp-config.php`
- **DB Credentials**: `C:\Projects\PiriReis\wordpress-db-credentials.txt`

---

## Database Info

- **Database**: wordpress_db
- **User**: wp_user
- **Host**: localhost
- **Port**: 3306

---

## Troubleshooting

**Can't connect to database?**

```powershell
Start-Service MySQL80
```

**Port 8000 in use?**

```powershell
php -S localhost:8080  # Use different port
```

---

**Full Docs**: See `SETUP_COMPLETE.md` and `WORDPRESS_SETUP_GUIDE.md`
