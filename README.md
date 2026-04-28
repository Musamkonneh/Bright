Theresy Brighter Future Education Center — School Management System

A cloud-based school management system built on Supabase with role-based access control (Admin, Teacher, Student). All data is stored securely in Supabase with no offline/local storage fallback.

## ⚡ Quick Start

### For Admins (Setup)
1. Read **[ADMIN_QUICK_START.md](ADMIN_QUICK_START.md)** for 3-step setup
2. Run `create_admin.bat` to create admin account: `admin@school.com` / `admin123`
3. Update `index.html` with your Supabase credentials
4. Open `index.html` in browser and log in as admin

### For Users (After Admin Setup)
- **Admin** creates student/teacher accounts with passwords
- Users receive credentials and log in
- No self-registration allowed
- All data synced to Supabase

## 📚 Documentation

- **[ADMIN_QUICK_START.md](ADMIN_QUICK_START.md)** — 3-step setup guide for admins
- **[ADMIN_SETUP.md](ADMIN_SETUP.md)** — Detailed admin account setup and troubleshooting
- **[ADMIN_ACCOUNT_MANAGEMENT.md](ADMIN_ACCOUNT_MANAGEMENT.md)** — Full admin-only account management workflow
- **[README_SUPABASE.md](README_SUPABASE.md)** — Supabase configuration and Edge Function deployment

## 🔐 Key Features

✅ **Cloud-Based Authentication** — Supabase Auth (no local fallback)
✅ **Admin-Only Account Creation** — Users cannot self-register
✅ **Role-Based Access Control** — Admin, Teacher, Student roles
✅ **Real-Time Data Sync** — All data stored in Supabase PostgreSQL
✅ **Secure Photo Storage** — Photos stored in Supabase Storage
✅ **Session Persistence** — Users stay logged in across browser restarts
✅ **No Offline Mode** — Cloud-first design (Supabase required)

## 👥 Account Model

### Pre-Created Admin Account
- **Email:** `admin@school.com`
- **Password:** `admin123`
- **Role:** Admin

### Account Creation
- Only admin can create new accounts
- Admin specifies email and password
- System creates Supabase account automatically
- Students/Teachers log in with admin-provided credentials

### User Roles

| Role | Can Do | Cannot Do |
|------|--------|-----------|
| **Admin** | Create/edit/delete students & teachers<br>Manage classes<br>View all data | Create other admins (UI) |
| **Teacher** | View assigned students<br>Enter grades<br>Mark attendance | Create accounts<br>View all students |
| **Student** | View grades<br>View attendance<br>View classes | Modify data<br>Create accounts |

## 🚀 Local Development

```bash
# Clone or download this project
cd "SCHOOL MANAGEMENT"

# If serving locally (optional):
# Option 1: Node.js http-server
npm i -g http-server
http-server -c-1 .

# Option 2: Python 3
python -m http.server 8000

# Then open http://localhost:8000 in browser
```

## ☁️ Supabase Setup

1. Create project at https://app.supabase.com
2. Get your URL and Anon Key
3. Update `index.html` with credentials (around line 1400)
4. Apply schema from `supabase-sql/schema.sql`
5. Deploy Edge Function from `functions/create-user/`
6. Create "photos" Storage bucket
7. Run `create_admin.bat` to create admin account

## 🌐 Deploy

### GitHub Pages
```bash
git init
git add .
git commit -m "Initial commit"
git remote add origin https://github.com/YOUR_USERNAME/school-management.git
git push -u origin main
# Then enable Pages in repo Settings
```

### Netlify
- Connect GitHub repo to Netlify
- Publish directory: `.` (root)
- Deploy

### Vercel
- Import GitHub repo
- Deploy automatically

## ⚠️ Important Notes

- **No local storage** — All data requires Supabase
- **No self-registration** — Only admin creates accounts
- **No offline mode** — Internet connection required
- **Service role key** — Keep it secret (use only in backend)
- **Admin credentials** — Change password after first login if needed

## 🆘 Troubleshooting

**"System not configured"**
- Check Supabase URL and Anon Key in `index.html`

**"Invalid credentials" on admin login**
- Verify admin account was created: `create_admin.bat`
- Check email/password: `admin@school.com` / `admin123`

**Can't create accounts**
- Ensure logged in as admin
- Check Edge Function is deployed
- Check browser console for errors

## 📝 License

This is a school management system built with Supabase and JavaScript.

## 📞 Support

See documentation files for detailed guides:
- Admins: Read `ADMIN_QUICK_START.md`
- Issues: Check `ADMIN_SETUP.md` troubleshooting section
- Setup: Follow `README_SUPABASE.md` configuration steps
