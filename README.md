# Piri Reis Investment Partners

**Tagline:** Navigating Growth. Creating Value.

Pioneering private equity and business consulting for the MENA region with focus on Saudi and Egyptian markets. Our firm is inspired by the legendary navigator Piri Reis, who symbolizes our commitment to guiding businesses through complex financial landscapes with precision and expertise.

## About Us

We specialize in strategic investment management, end-to-end M&A support, IPO readiness, and advanced consulting—fully aligned with Saudi and Egyptian regulations and global best practices.

### Our Solutions

1. **Private Equity Fund Management**
2. **M&A Lifecycle Management**
3. **Valuation & Deal Document Review**
4. **Business Consulting**
5. **IPO Preparation Suite**

### Why Choose Us?

1. Deep regulatory expertise in Saudi and Egyptian markets
2. Proven track record in value creation and transformation
3. Trusted partner for ambitious companies and investors

## Our Services

### 1. Private Equity Fund Management

- Sourcing, structuring, and managing investments in high-potential Saudi and Egyptian businesses
- Active portfolio management and value creation
- Exit planning including IPOs and M&A

### 2. M&A Lifecycle Management

- Target identification and evaluation
- Due diligence and deal structuring
- Regulatory approval and integration support

### 3. IPO Preparation Suite

- IPO readiness assessment and planning
- Prospectus and disclosure preparation (Tadawul, Nomu, EGX compliance)
- Stakeholder and advisor coordination

### 4. Valuation & Deal Document Review

- Review of valuation reports (Taqeem/IVS standards)
- Review of Term Sheets, Shareholders Agreements (SHAs), and Sale and Purchase Agreements (SPAs)
- Legal and financial due diligence

### 5. Business Consulting

- Financial restructuring and turnaround management
- Strategic growth and transformation advisory
- Regulatory compliance and reporting (FRA, SOCPA, EISAR, NMOU)

## PreStruct Platform

We're developing **PreStruct**, a comprehensive digital platform addressing the challenges Saudi companies face in managing financial distress, navigating complex restructuring procedures, and preparing for capital market activities.

### Key Features

- Early warning system for financial distress
- Guided workflows for restructuring and bankruptcy
- M&A lifecycle management tools
- IPO readiness suite
- Secure document vault and expert consultation access

### Regulatory Alignment

- **Saudi Bankruptcy Law**: Financial Restructuring Procedure (FRP), Protective Settlement, and Liquidation
- **EISAR**: Trustee and expert verification, fee structures, procedural compliance
- **Tadawul and Nomu**: IPO readiness tools based on listing requirements
- **SOCPA**: Financial reporting compliance during restructuring and liquidation
- **Taqeem**: Valuation standards and accredited valuer documentation

---

## Development Setup Instructions

This repository contains the WordPress development environment for the Piri Reis website.

### Prerequisites

1. Install PHP 8.4+ and MySQL 8.0
2. Ensure PowerShell execution policy allows script execution

### Setup Process

Run setup scripts in the following order:

```powershell
# 1. Download WordPress to website/ directory
.\setup-wordpress.ps1

# 2. Create database and user
.\setup-mysql-database.ps1

# 3. Configure WordPress with database credentials
.\configure-wordpress.ps1

# 4. Validate environment setup
.\check-setup.ps1
```

### Daily Development

```powershell
# Start development server
cd website
php -S localhost:8000
```

- **Frontend**: <http://localhost:8000>
- **Admin Panel**: <http://localhost:8000/wp-admin>

### Troubleshooting

```powershell
# Check environment status
.\check-setup.ps1

# Check MySQL service
Get-Service MySQL80
Start-Service MySQL80  # If stopped
```

See `QUICK_START.md` for detailed setup instructions and `DAILY_REFERENCE.md` for development commands.
