# Quick Start Guide - Admin Account Setup

## 🎯 Goal
Set up the School Management System with a pre-created admin account, then use the admin dashboard to create all other accounts.

## 📋 Prerequisites
- Supabase project created (https://app.supabase.com)
- Node.js installed
- Your Supabase URL and Service Role Key ready

## ⚡ Quick Setup (3 Steps)

### Step 1: Get Your Supabase Credentials

1. Go to https://app.supabase.com → Your Project
2. Click **Settings → API**
3. Copy:
   - **Project URL** (e.g., `https://your-project.supabase.co`)
   - **Service Role Key** (⚠️ Keep this secret!)

### Step 2: Create Admin Account

**Using PowerShell:**

```powershell
# Set environment variables
$env:SUPABASE_URL = 'https://your-project.supabase.co'
$env:SUPABASE_SERVICE_ROLE_KEY = 'your-service-role-key'

# Navigate to project
cd "C:\Users\Konneh\Documents\SCHOOL MANAGEMENT"

# Create admin account
.\create_admin.bat
```

You should see:
```
User created successfully: { user: { id: '...', email: 'admin@school.com', ... } }
```

### Step 3: Update index.html with Supabase Credentials

1. Open `index.html` in a text editor
2. Find this section (around line 1400):
   ```javascript
   const SUPABASE_URL = 'https://zvmftgptxrpkgvvmivtr.supabase.co';
   const SUPABASE_ANON_KEY = 'sb_publishable_w9PqCK-12Xd9xbP_zatm3Q_uTme3lDT';
   ```
3. Replace with your credentials:
   ```javascript
   const SUPABASE_URL = 'https://your-project.supabase.co';
   const SUPABASE_ANON_KEY = 'your-anon-key'; // Get from Settings → API
   ```

## ✅ Test Login

1. Open `index.html` in your browser
2. Login with:
   - **Email:** `admin@school.com`
   - **Password:** `admin123`
   - **Role:** Select "Admin"

## 📊 Create Your First Accounts

### Create a Student

1. Click **Students** in the sidebar
2. Click **"Add New Student"**
3. Fill in:
   - First Name: John
   - Last Name: Doe
   - ID Number: ST001
   - Grade: 5
   - Parent Contact: john@example.com
   - Email: john.doe@school.com
   - Password: password123
4. Click **"Save Student"**

The system automatically creates a Supabase account for John!

### Create a Teacher

1. Click **Teachers** in the sidebar
2. Click **"Add New Teacher"**
3. Fill in:
   - First Name: Jane
   - Last Name: Smith
   - ID Number: TC001
   - Email: jane.smith@school.com
   - Password: password123
   - Subjects: Check "Math" and "English"
4. Click **"Save Teacher"**

The system automatically creates a Supabase account for Jane!

## 🔐 Account Management Summary

| Who | Can Do | Cannot Do |
|-----|--------|-----------|
| **Admin** | ✅ Create students<br>✅ Create teachers<br>✅ Edit accounts<br>✅ Delete accounts | ❌ Create other admins (from UI) |
| **Teachers** | ✅ View students (their classes)<br>✅ Enter grades<br>✅ Mark attendance | ❌ Create accounts |
| **Students** | ✅ View their grades<br>✅ View their attendance | ❌ Do anything admin-related |

## 🚀 You're All Set!

Your School Management System is now:
- ✅ Running with admin account `admin@school.com`
- ✅ Storing all data in Supabase
- ✅ Ready to create student and teacher accounts
- ✅ No self-registration allowed

## ❓ Need Help?

See `ADMIN_SETUP.md` for:
- Detailed admin account creation
- Troubleshooting login issues
- Security notes
- Account management workflow

---

**Remember:** Only the admin can create new accounts. Share the student/teacher credentials with users after creating them in the admin dashboard!
