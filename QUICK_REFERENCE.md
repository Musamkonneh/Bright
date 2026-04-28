# Quick Reference Card

## 🎯 Your System Setup

**Admin Account (Pre-Created)**
```
Email:    admin@school.com
Password: admin123
Role:     Admin
```

**Key URLs & Credentials**
- Supabase Project: https://app.supabase.com
- Your Project URL: https://YOUR-PROJECT.supabase.co
- Get from: Settings → API

## 📋 Setup Checklist

- [ ] Create Supabase project
- [ ] Apply schema (`supabase-sql/schema.sql`)
- [ ] Update index.html Supabase credentials
- [ ] Deploy Edge Function (`functions/create-user/`)
- [ ] Create "photos" Storage bucket
- [ ] Run `create_admin.bat` to create admin account
- [ ] Test login: `admin@school.com` / `admin123`

## 💻 Commands Reference

### Create Admin Account
```powershell
# Set environment variables
$env:SUPABASE_URL = 'https://your-project.supabase.co'
$env:SUPABASE_SERVICE_ROLE_KEY = 'your-service-role-key'

# Run script
cd "C:\Users\Konneh\Documents\SCHOOL MANAGEMENT"
.\create_admin.bat
```

### Create Additional Admin Accounts
```powershell
$env:SUPABASE_URL = 'https://your-project.supabase.co'
$env:SUPABASE_SERVICE_ROLE_KEY = 'your-service-role-key'
node scripts\admin_create_user.js '{"email":"admin2@school.com","password":"admin123","role":"admin","full_name":"Admin Two"}'
```

### Serve Locally
```bash
# Option 1: Node.js
npm i -g http-server
http-server -c-1 .

# Option 2: Python
python -m http.server 8000

# Then visit: http://localhost:8000
```

## 🔐 Credentials

### Supabase API Keys (in index.html)

Find these in Supabase Settings → API:

```javascript
const SUPABASE_URL = 'https://YOUR-PROJECT.supabase.co';
const SUPABASE_ANON_KEY = 'your-anon-key-here';
const SUPABASE_EDGE_CREATE_USER_URL = 'https://YOUR-PROJECT.supabase.co/functions/v1/create-user';
```

**⚠️ WARNING:**
- Never commit these keys to public repos
- Use .env file for local development
- Rotate keys regularly

## 👥 Account Management

### Create Student (Admin Only)
1. Log in as admin
2. Click **Students** → **Add New Student**
3. Fill form, set email & password
4. Click **Save Student**
5. System creates Supabase account automatically

### Create Teacher (Admin Only)
1. Log in as admin
2. Click **Teachers** → **Add New Teacher**
3. Fill form, set email & password, assign subjects
4. Click **Save Teacher**
5. System creates Supabase account automatically

### Create Class (Admin Only)
1. Log in as admin
2. Click **Classes** → **Add New Class**
3. Select teacher and students
4. Click **Save Class**

## 📊 User Roles

```
ADMIN
  ├─ Create accounts (Students/Teachers)
  ├─ Manage classes
  ├─ View all data
  └─ Manage attendance/grades

TEACHER
  ├─ View assigned students
  ├─ Enter grades
  ├─ Mark attendance
  └─ Cannot create accounts

STUDENT
  ├─ View own grades
  ├─ View own attendance
  ├─ View classes
  └─ Cannot create/modify anything
```

## 🆘 Troubleshooting

| Problem | Solution |
|---------|----------|
| "System not configured" | Check Supabase credentials in index.html |
| Can't log in as admin | Run `create_admin.bat` to create account |
| "Invalid credentials" | Use: `admin@school.com` / `admin123` |
| Can't create accounts | Must be logged in as admin |
| Photos won't upload | Create "photos" Storage bucket in Supabase |
| Edge Function errors | Check function is deployed in Supabase |

## 📚 Documentation Files

- **README.md** — System overview
- **ADMIN_QUICK_START.md** — 3-step setup
- **ADMIN_SETUP.md** — Detailed setup guide
- **ADMIN_ACCOUNT_MANAGEMENT.md** — Full workflow
- **SYSTEM_ARCHITECTURE.md** — Technical architecture
- **README_SUPABASE.md** — Supabase configuration

## 🚀 Deployment Options

### GitHub Pages
```bash
git init
git add .
git commit -m "School Management System"
git remote add origin https://github.com/YOUR_USERNAME/school-management.git
git push -u origin main
# Then enable Pages in repo Settings
```

### Netlify
- Connect GitHub repo
- Deploy automatically

### Vercel
- Import GitHub repo
- Deploy automatically

## 🔗 Important Links

- Supabase Dashboard: https://app.supabase.com
- Your Project: https://YOUR-PROJECT.supabase.co
- PostgreSQL Docs: https://www.postgresql.org/docs/
- Supabase Docs: https://supabase.com/docs

## 📞 Support

1. Read the relevant documentation file first
2. Check troubleshooting section in ADMIN_SETUP.md
3. Check browser console for error messages
4. Review Supabase logs in Dashboard

## ✅ System Ready When:

- [x] Admin account created
- [x] index.html has Supabase credentials
- [x] Edge Function deployed
- [x] Storage bucket "photos" created
- [x] Admin can log in and create accounts
- [x] Students/Teachers can log in with credentials provided by admin

---

**That's it!** Your admin-controlled school management system is ready to use. 🎓
