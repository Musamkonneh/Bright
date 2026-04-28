# Admin-First Account Management System

## 📌 System Overview

The School Management System now operates with a **strict admin-first account management model**:

### Core Principles

1. **Only ONE pre-created account exists:** `admin@school.com` (password: `admin123`)
2. **Admin controls all accounts:** Only the admin can create, edit, or delete student/teacher accounts
3. **No self-registration:** The registration page is completely removed
4. **Cloud-only data:** All account and data information is stored in Supabase (no local fallback)
5. **Secure account creation:** New accounts are created via Supabase Edge Functions (service role key never exposed to client)

---

## 🔄 Account Lifecycle

### Phase 1: Admin Account Setup (One-Time)

```
1. Admin runs create_admin.bat script
   ↓
2. Supabase creates admin@school.com account
   ↓
3. Admin logs in via web app
   ✅ System is now ready for use
```

### Phase 2: Student/Teacher Creation (Admin Only)

**Admin creates a student:**
```
1. Admin clicks "Students" → "Add New Student"
   ↓
2. Admin fills in student details and sets password
   ↓
3. System calls Edge Function to create Supabase account
   ↓
4. Student record is created in database
   ↓
5. Admin shares credentials with student
   ✅ Student can now log in
```

**Same process for teachers:**
```
1. Admin clicks "Teachers" → "Add New Teacher"
2. Admin fills in teacher details and sets password
3. System creates Supabase account via Edge Function
4. Teacher record is created in database
5. Admin shares credentials with teacher
✅ Teacher can now log in
```

### Phase 3: User Login

**Any user (admin/teacher/student):**
```
1. User opens the web app
   ↓
2. Enters email, password, and role
   ↓
3. System authenticates against Supabase
   ↓
4. User data is loaded from Supabase
   ↓
✅ User is logged in and sees role-appropriate dashboard
```

---

## 👨‍💼 Admin User Flow

### Login
```
Email: admin@school.com
Password: admin123
Role: Admin
```

### Dashboard View
Admin sees:
- Total students count
- Total teachers count
- Total classes count
- Recent activities log
- Quick links to Students, Teachers, Classes pages

### Admin Actions
- ✅ Add new students (with password)
- ✅ Edit student information
- ✅ Delete students
- ✅ Add new teachers (with password)
- ✅ Edit teacher information
- ✅ Delete teachers
- ✅ Create and manage classes
- ✅ View all attendance records
- ✅ View all grades

### What Admin CANNOT Do
- ❌ Create other admin accounts (from UI - would need direct Supabase modification)
- ❌ Change user passwords after account creation (users can use password reset if Supabase is configured)
- ❌ Grant special permissions to existing users

---

## 👨‍🏫 Teacher User Flow

### Login
```
Email: [Created by admin]
Password: [Set by admin, can change after first login]
Role: Teacher
```

### Dashboard View
Teachers see:
- Number of students in their classes
- Number of their assigned classes
- Classes they teach

### Teacher Actions
- ✅ View their assigned students
- ✅ View and manage attendance for their classes
- ✅ Enter and manage grades for their subjects
- ✅ View their profile

### What Teacher CANNOT Do
- ❌ Create new accounts
- ❌ Delete students
- ❌ Modify attendance/grades for classes they don't teach
- ❌ Access admin functions

---

## 👨‍🎓 Student User Flow

### Login
```
Email: [Created by admin]
Password: [Set by admin, can change after first login]
Role: Student
```

### Dashboard View
Students see:
- Their average grade
- Their attendance percentage
- Their enrolled classes

### Student Actions
- ✅ View their grades (organized by subject and semester)
- ✅ View their attendance records
- ✅ View their enrolled classes and teachers

### What Student CANNOT Do
- ❌ Create accounts
- ❌ Edit grades
- ❌ Modify attendance records
- ❌ Access admin functions
- ❌ See other students' information

---

## 🔐 Security Model

### Authentication
- **Provider:** Supabase Auth
- **Method:** Email + Password
- **Session:** Persistent across browser restarts (stored in Supabase session)
- **Fallback:** None (Supabase required)

### Account Creation
- **Who:** Admin only (via web interface)
- **Method:** Edge Function (service role key kept on server, never exposed)
- **Data:** Stored in Supabase (profiles table + student/teacher tables)

### Data Access
- **Row Level Security (RLS):** Enforced on all tables
  - Admins can see everything
  - Teachers can only see their classes/students
  - Students can only see their own data
- **Local Storage:** NONE (all data from Supabase)
- **Offline Mode:** Not supported (cloud-only)

---

## 📋 Pre-Requisites for Deployment

Before going live with your system:

1. ✅ Admin account created (`admin@school.com` / `admin123`)
2. ✅ Supabase credentials in `index.html`
3. ✅ Edge Function deployed for `adminCreateAuthUser()`
4. ✅ Storage bucket "photos" created (for student/teacher photos)
5. ✅ RLS policies enabled on all tables
6. ✅ Admin has tested account creation workflow

---

## ⚙️ Configuration Files

### `create_admin.bat`
- Runs `admin_create_user.js` with admin credentials
- Creates the initial admin account in Supabase
- Must be run once before system is used

### `index.html`
- Contains Supabase URL and Anon Key
- Contains Edge Function URL for account creation
- Implements admin-only account creation logic
- Removed registration page entirely

### `scripts/admin_create_user.js`
- Node.js script that uses Supabase admin API
- Requires SERVICE_ROLE_KEY (must be set as environment variable)
- Creates user in Supabase Auth and updates profile with role

---

## 🚀 Deployment Checklist

### Pre-Launch
- [ ] Supabase project created and schema applied
- [ ] Admin account created via `create_admin.bat`
- [ ] `index.html` updated with Supabase credentials
- [ ] Edge Function deployed
- [ ] Admin tested login flow
- [ ] Admin tested student creation
- [ ] Admin tested teacher creation
- [ ] RLS policies verified
- [ ] Storage bucket "photos" created

### Launch
- [ ] Deploy `index.html` to web server
- [ ] Share admin login credentials securely
- [ ] Provide admin with account creation guide
- [ ] Document admin-only account management policy

### Post-Launch
- [ ] Monitor Supabase usage
- [ ] Monitor account creation activity
- [ ] Backup Supabase data regularly
- [ ] Update admin if account creation process needs changes

---

## 📞 Admin Support

If you need to:

**Create a student/teacher account:**
- Use the web interface (Students/Teachers pages)
- System automatically creates Supabase account

**Reset a user's password:**
- Configure password reset in Supabase Auth settings
- User can request password reset from login page (if configured)

**Delete a user:**
- Use the delete button next to student/teacher record
- System removes from database and Supabase Auth

**Create additional admin accounts:**
- Run admin_create_user.js with admin role:
  ```powershell
  $env:SUPABASE_URL = 'https://your-project.supabase.co'
  $env:SUPABASE_SERVICE_ROLE_KEY = 'your-key'
  node scripts\admin_create_user.js '{"email":"admin2@school.com","password":"admin123","role":"admin","full_name":"Admin Two"}'
  ```

---

**The key principle: Admin creates all accounts, users cannot self-register.**
