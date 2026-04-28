# System Architecture Overview

## 🏗️ High-Level Architecture

```
┌─────────────────────────────────────────────────────────┐
│           School Management System                      │
│         (Cloud-First, Admin-Controlled)                │
└─────────────────────────────────────────────────────────┘
                          │
                          ↓
         ┌─────────────────────────────────┐
         │      Web Interface (HTML/JS)    │
         │  - Login (Email/Password/Role)  │
         │  - Dashboard (Role-Based)       │
         │  - Admin Panel (Accounts)       │
         │  - Student/Teacher Views        │
         └─────────────────────────────────┘
                          │
                          ↓
         ┌─────────────────────────────────┐
         │    Supabase Auth & API          │
         │  - JWT Authentication           │
         │  - Real-Time Sync               │
         │  - Edge Functions               │
         └─────────────────────────────────┘
                          │
                          ↓
         ┌─────────────────────────────────┐
         │    PostgreSQL Database          │
         │  - profiles (Users)             │
         │  - students                     │
         │  - teachers                     │
         │  - classes                      │
         │  - grades                       │
         │  - attendance                   │
         └─────────────────────────────────┘
```

## 👥 Account Creation Flow

### Initial Setup (One-Time)

```
Step 1: Run create_admin.bat
  ↓
Step 2: Supabase creates admin@school.com
  ↓
Step 3: Admin logs in via web app
  ↓
✅ System ready for user account creation
```

### User Account Creation (Admin Only)

```
Admin Dashboard
  ↓
Students/Teachers Page
  ↓
"Add New Student/Teacher" Form
  ↓
Admin enters email & password
  ↓
Edge Function creates Supabase Auth user
  ↓
Student/Teacher record created in DB
  ↓
Admin shares credentials with user
  ↓
✅ User can log in
```

## 🔐 Authentication Layers

```
Layer 1: Web Interface
├─ Login form (email, password, role)
└─ Session validation

Layer 2: Supabase Auth
├─ JWT token generation
├─ Password verification
└─ Session management

Layer 3: Row-Level Security
├─ Admin sees all data
├─ Teachers see their classes/students
└─ Students see only their data

Layer 4: Database
├─ encrypted passwords
├─ role-based access
└─ audit logs
```

## 📊 User Roles & Permissions

```
┌────────────────────────────────────────────────────────┐
│                    ADMIN                               │
├────────────────────────────────────────────────────────┤
│ ✅ Create students        ✅ Create teachers            │
│ ✅ Edit accounts          ✅ Delete accounts            │
│ ✅ Manage classes         ✅ View all data              │
│ ✅ View all grades        ✅ View all attendance        │
│ ❌ Create other admins    ❌ Modify database directly   │
└────────────────────────────────────────────────────────┘
                          │
            ┌─────────────┴─────────────┐
            ↓                           ↓
   ┌────────────────────┐      ┌────────────────────┐
   │    TEACHER         │      │    STUDENT         │
   ├────────────────────┤      ├────────────────────┤
   │✅ View students    │      │✅ View grades      │
   │✅ Enter grades     │      │✅ View attendance  │
   │✅ Mark attendance  │      │✅ View classes     │
   │❌ Create accounts  │      │❌ Create accounts  │
   │❌ Edit other data  │      │❌ Modify data      │
   └────────────────────┘      └────────────────────┘
```

## 🔄 Data Flow

### Create Account (Admin)

```
Admin Interface
    │
    ├─ Collects: name, email, password, role
    │
    ↓
adminCreateAuthUser() Edge Function
    │
    ├─ Supabase Auth: create user (email/password)
    ├─ Profiles table: store role
    ├─ Students/Teachers table: store details
    │
    ↓
Database Updated
    │
    ├─ Auth User Record (supabase.auth.users)
    ├─ Profile Record (user_id + role)
    ├─ Student/Teacher Record (all details)
    │
    ↓
✅ Account Ready
   New user logs in with credentials
```

### Login (Any User)

```
User Login Form
    │
    ├─ Email, Password, Role
    │
    ↓
Supabase Auth
    │
    ├─ Verify credentials
    ├─ Generate JWT token
    ├─ Query profiles table for role
    │
    ↓
Application
    │
    ├─ Load profile data
    ├─ Load role-appropriate records
    ├─ Apply RLS policies
    │
    ↓
Dashboard Rendered
    │
    ├─ Admin: admin dashboard
    ├─ Teacher: teacher dashboard
    ├─ Student: student dashboard
    │
    ↓
✅ User logged in
```

## 📁 File Structure

```
SCHOOL MANAGEMENT/
├── index.html                          # Main application
│
├── create_admin.bat                    # Create admin account (Windows)
│
├── scripts/
│   ├── admin_create_user.js            # Node.js admin creation script
│   └── import_demo.js                  # Demo data import
│
├── functions/
│   └── create-user/
│       └── index.ts                    # Edge Function for account creation
│
├── supabase-sql/
│   ├── schema.sql                      # Database schema
│   └── corrected_schema.sql            # Updated schema
│
├── frontend/
│   └── supabase-snippets.md            # JS snippets reference
│
├── README.md                           # Main documentation
├── ADMIN_QUICK_START.md                # 3-step setup for admins
├── ADMIN_SETUP.md                      # Detailed admin setup
├── ADMIN_ACCOUNT_MANAGEMENT.md         # Account management workflow
├── README_SUPABASE.md                  # Supabase configuration
│
└── [Other documentation files]
```

## ⚡ Key Technologies

| Component | Technology | Purpose |
|-----------|-----------|---------|
| **Frontend** | HTML5 + CSS3 + JavaScript | User interface |
| **Authentication** | Supabase Auth + JWT | User login & session |
| **Database** | PostgreSQL (via Supabase) | Data storage |
| **API** | Supabase REST API | CRUD operations |
| **Functions** | Deno (Supabase Functions) | Admin user creation |
| **Storage** | Supabase Storage | Photo uploads |
| **RLS** | PostgreSQL RLS | Row-level security |

## 🔒 Security Model

### Authentication
- ✅ Password hashing (Supabase Auth)
- ✅ JWT tokens (server-side validation)
- ✅ HTTPS only (enforced by Supabase)
- ✅ Session persistence (secure cookies)

### Authorization
- ✅ Role-based access control (Admin/Teacher/Student)
- ✅ Row-level security (PostgreSQL RLS)
- ✅ Service role key on server only (never exposed)
- ✅ Anon key for client (limited permissions)

### Data Protection
- ✅ No local storage (cloud-first)
- ✅ Encrypted transmission (HTTPS)
- ✅ Database backups (Supabase managed)
- ✅ Audit logs available

## 🚀 Deployment Steps

1. **Create Supabase Project**
   - https://app.supabase.com

2. **Apply Database Schema**
   - Run `supabase-sql/schema.sql` in SQL Editor

3. **Deploy Edge Function**
   - Upload `functions/create-user/index.ts`
   - Set environment variables
   - Get function URL

4. **Configure index.html**
   - Update SUPABASE_URL
   - Update SUPABASE_ANON_KEY
   - Update SUPABASE_EDGE_CREATE_USER_URL

5. **Create Admin Account**
   - Run `create_admin.bat`
   - Credentials: admin@school.com / admin123

6. **Deploy Frontend**
   - Host index.html on static server
   - Or GitHub Pages / Netlify / Vercel

7. **Configure Storage**
   - Create "photos" bucket
   - Set permissions (public or private)

## 📈 Scalability

- ✅ Supabase handles user growth
- ✅ Automatic backups & replication
- ✅ Real-time subscriptions supported
- ✅ Edge Functions for complex operations
- ✅ PostgreSQL performance tuning available

## 🔄 Future Enhancements

Possible additions (not implemented):
- Password reset via email
- Two-factor authentication
- Attendance QR codes
- Grade report generation
- Parent portal
- Mobile app
- API for third-party integrations

---

**Summary:** A clean, secure, cloud-first school management system where admins control all account creation and users cannot self-register.
