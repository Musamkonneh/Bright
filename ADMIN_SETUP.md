# Admin Account Setup & Account Management Guide

## Pre-Created Admin Account

The system comes with a pre-created admin account that you must set up in Supabase:

### Admin Credentials
- **Email:** `admin@school.com`
- **Password:** `admin123`
- **Role:** `admin`

### Creating the Admin Account in Supabase

#### Option 1: Using the Batch Script (Windows)

1. **Set Environment Variables:**
   - Open PowerShell and set your Supabase credentials:
   ```powershell
   $env:SUPABASE_URL = 'https://your-project.supabase.co'
   $env:SUPABASE_SERVICE_ROLE_KEY = 'your-service-role-key'
   ```

2. **Run the Script:**
   ```powershell
   cd "C:\Users\Konneh\Documents\SCHOOL MANAGEMENT"
   .\create_admin.bat
   ```

   OR directly run:
   ```powershell
   node scripts\admin_create_user.js '{"email":"admin@school.com","password":"admin123","role":"admin","full_name":"Administrator"}'
   ```

#### Option 2: Manual Creation via Supabase Dashboard

1. Go to your Supabase project dashboard
2. Navigate to **Authentication → Users**
3. Click **"Add User"**
4. Enter the credentials:
   - Email: `admin@school.com`
   - Password: `admin123`
   - Check "Auto Confirm User"
5. Click **"Create User"**
6. Go to the **SQL Editor** and run:
   ```sql
   UPDATE profiles 
   SET role = 'admin', full_name = 'Administrator'
   WHERE email = 'admin@school.com';
   ```

---

## Account Management Workflow

### ✅ Admin Can Only Create Accounts

Once the admin is logged in, only the admin can create new accounts:

1. **Creating Student Accounts:**
   - Click **"Students"** in the sidebar
   - Click **"Add New Student"**
   - Fill in the form (First Name, Last Name, Email, Password, etc.)
   - Click **"Save Student"**
   - System automatically creates a Supabase auth account for the student

2. **Creating Teacher Accounts:**
   - Click **"Teachers"** in the sidebar
   - Click **"Add New Teacher"**
   - Fill in the form (First Name, Last Name, Email, Password, Subjects, etc.)
   - Click **"Save Teacher"**
   - System automatically creates a Supabase auth account for the teacher

### ❌ No Self-Registration

- **The registration page has been removed**
- **Users cannot create their own accounts**
- **Only admins can create accounts through the admin interface**

---

## Default Accounts After Setup

After creating the admin account, the system will have:

| Email | Password | Role | Created By |
|-------|----------|------|-----------|
| admin@school.com | admin123 | Admin | (Pre-created) |

Additional accounts will be created only by the admin through the admin dashboard.

---

## Security Notes

⚠️ **Important:**
- The `admin@school.com` account is the **master account** for the system
- Change the password after first login if needed
- Never share admin credentials
- All new account creation goes through the admin interface
- Edge Functions handle secure account creation (service role key is not exposed to clients)

---

## Troubleshooting

### "System not configured. Please contact the administrator."
- Supabase URL or Anon Key not set in `index.html`
- Check that your Supabase credentials are correct

### "Invalid credentials" on login
- Verify the admin account was created successfully
- Check that the email and password are correct: `admin@school.com` / `admin123`
- Verify the account is confirmed in Supabase (check Auth → Users)

### Can't create student/teacher accounts
- Ensure you're logged in as admin
- Check that the Edge Function is deployed (if using cloud account creation)
- Check browser console for error messages

---

## Next Steps

1. ✅ Set Supabase credentials in PowerShell
2. ✅ Run `create_admin.bat` to create the admin account
3. ✅ Log in to the system with `admin@school.com` / `admin123`
4. ✅ Create student and teacher accounts through the admin dashboard
5. ✅ Share student/teacher credentials with appropriate users

**That's it!** The system is now ready to use with admin-only account management.
