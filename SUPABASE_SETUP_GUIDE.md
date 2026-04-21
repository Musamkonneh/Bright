# Supabase Integration Setup Guide

## Overview
Your School Management System is now fully integrated with Supabase for cloud data persistence. This means:
- ✅ All accounts created are saved to the Supabase database
- ✅ Accounts work across all devices - just log in with the same credentials
- ✅ All student, teacher, grade, and attendance data is automatically synced
- ✅ Local storage is used as a fallback for offline access

## What You've Set Up

### 1. Supabase Project
- **URL**: https://zvmftgptxrpkgvvmivtr.supabase.co
- **Anon Key**: sb_publishable_Xh6q2He9p_DM2rl-u5rkow_-PMH18Bn

### 2. Database Schema
The following tables are automatically created and managed:

#### `profiles`
- Stores user authentication data and roles
- Linked to Supabase Auth system
- Supports roles: admin, teacher, student

#### `students`
- Stores student information
- Auto-linked to profiles through foreign keys
- Includes: first_name, last_name, student_id, email, enrollment_date

#### `teachers`
- Stores teacher information
- Auto-linked to profiles through foreign keys
- Includes: first_name, last_name, id_number, email, hire_date, subjects

#### `classes`
- Stores class information
- Links teachers and students

#### `grades`
- Stores student grades by subject and period

#### `attendance`
- Stores attendance records with status (Present, Absent, Late, Excused)

## How It Works

### Creating a New Account
1. **Registration**: When a student or teacher registers through the website:
   - Account is created in Supabase Auth (secure password storage)
   - Profile is automatically created in the `profiles` table
   - A trigger automatically creates corresponding student/teacher records

2. **Data Persistence**: All account data is saved to Supabase immediately

3. **Cross-Device Access**: Users can log in from any device using the same email/password

### Syncing Data
The system automatically syncs the following to Supabase:

1. **When a Student is Added**: 
   - Student record is created in the `students` table
   - Can be accessed from any admin/teacher account

2. **When a Teacher is Added**:
   - Teacher record is created in the `teachers` table
   - Subjects are automatically stored as an array

3. **When Grades are Recorded**:
   - Grades are saved to the `grades` table
   - Automatically synced to Supabase
   - Can be accessed from any device

4. **When Attendance is Marked**:
   - Attendance records are saved to the `attendance` table
   - Synced to Supabase for permanent storage

### Session Recovery
When you open the site:
1. The system checks if you have an active Supabase session
2. If you're logged in (from any device), you'll be automatically authenticated
3. Your profile data is loaded from Supabase
4. You can immediately access the dashboard

## User Roles

### Admin
- Can create, edit, and delete students and teachers
- Can mark attendance and enter grades
- Can view all data
- Default admin account: `admin@school.com` / `admin123`

### Teacher
- Can mark attendance for their classes
- Can enter grades
- Can view student information
- Must be created by admin

### Student
- Can view their own grades
- Can view their own attendance
- Can only access their own data
- Must be created by admin or register themselves

## Testing the Integration

### Test 1: Create a New Account
1. Go to the registration page
2. Fill in details (e.g., email: test@example.com, password: Test1234!)
3. Check if the account is created in your Supabase dashboard
4. Try logging in from a different browser/device with the same credentials

### Test 2: Add a Student via Admin
1. Log in as admin
2. Add a new student through the "Students" section
3. Check the Supabase `students` table to verify the record exists
4. The record should be immediately accessible

### Test 3: Record Grades
1. Log in as a teacher
2. Record some grades for a class
3. Check the Supabase `grades` table
4. Log in as a student and verify they can see their grades

### Test 4: Mark Attendance
1. Log in as a teacher
2. Mark attendance for a class
3. Check the Supabase `attendance` table
4. The records should be saved with proper student IDs and status

## Important Notes

### Email Confirmation
- If you have email confirmation enabled in Supabase, new users will need to verify their email
- To disable: Go to Supabase dashboard → Authentication → Providers → Email → Toggle "Confirm email"

### Password Reset
- Users can reset forgotten passwords through email (if enabled)
- To set up: Configure SMTP in Supabase Auth settings

### Offline Mode
- The system works offline using localStorage
- Data will sync to Supabase when internet is restored
- Local data is always kept in sync with what's displayed

### Row Level Security (RLS)
- RLS policies are in place to protect data
- Users can only see their own data (students see their own records)
- Admins and teachers can see student data
- Admins can see all data

## Troubleshooting

### Data Not Syncing to Supabase
1. Check the browser console (F12 → Console tab)
2. Look for error messages starting with "Supabase"
3. Verify the URL and API key are correct
4. Check your internet connection

### Users Can't Log In
1. Make sure email confirmation is disabled (if not using email)
2. Check the `profiles` table to ensure the record exists
3. Verify the email address matches exactly (case-insensitive)

### Grades Not Saving
1. Make sure you're logged in as a teacher or admin
2. Check the `grades` table in Supabase dashboard
3. Verify the grade value is a valid number

### Attendance Not Recording
1. Ensure you've selected the correct class and date
2. Check the `attendance` table in Supabase
3. Make sure attendance records are properly formatted

## Database Access

To view your data in Supabase:
1. Go to https://app.supabase.com
2. Log in with your Supabase account
3. Select your project
4. Go to SQL Editor → Browse tables
5. You'll see all the data being synced from the application

## Next Steps

### Deploy Your Application
To make this accessible online:
1. Host the `index.html` file on a web server
2. Or use services like:
   - GitHub Pages (free)
   - Vercel (free tier available)
   - Netlify (free tier available)

### Enable Email Notifications
1. Go to Supabase dashboard
2. Settings → Email Templates
3. Configure SMTP for password reset and email verification emails

### Set Up More Supabase Features
- Database backups (automatic)
- Real-time subscriptions (for live data updates)
- Custom functions for advanced workflows
- Storage for document uploads

## Support

If you encounter issues:
1. Check the browser console for error messages
2. Verify Supabase credentials are correct
3. Check Supabase dashboard for any service warnings
4. Ensure your internet connection is working

---

**Your system is now fully cloud-enabled! All accounts and data will be saved securely in Supabase.**
