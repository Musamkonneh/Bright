# 🧪 Testing Guide - School Management System

## Quick Start (10 minutes)

### Test 1: Local Server Setup ✅
```bash
# Option A: Using Node.js (easiest)
npm install -g http-server
http-server -c-1 .

# Option B: Using Python 3
python -m http.server 8000

# Option C: Direct browser (no server needed)
# Just double-click index.html or drag to browser
```

Then open: **http://localhost:8000** (or just open index.html)

---

## Test Suite 1: Registration & Login (5 min)

### Test 1.1: Create a Test Account
**Steps:**
1. Click **Registration** tab
2. Fill form:
   - Email: `test@example.com`
   - Username: `testuser`
   - Password: `Test123456`
   - Role: **Student** (dropdown)
   - Full Name: `Test User`
3. Click **Register**
4. **Expected**: "Account created successfully" message
5. **Check**: Account appears in Supabase dashboard
   - Go to: https://app.supabase.com
   - Click your project
   - Go to: SQL Editor → Browse → **profiles** table
   - Should see: `test@example.com` with role = `student`

### Test 1.2: Login with New Account
**Steps:**
1. Click **Login** tab
2. Enter:
   - Email: `test@example.com`
   - Password: `Test123456`
3. Click **Login**
4. **Expected**: Dashboard appears, sidebar shows "STUDENT" mode
5. **Check Console**: Open Developer Tools (F12 → Console)
   - Should see: "✓ Sync successful" messages
   - Should NOT see: Red error messages

---

## Test Suite 2: Data Sync (Admin) (10 min)

### Prerequisites
Create admin account first:
- Email: `admin@school.com`
- Password: `Admin123456`
- Role: **Admin**

### Test 2.1: Add Student (Admin)
**Steps:**
1. Login as admin
2. Click **Students** in sidebar
3. Click **Add New Student**
4. Fill form:
   - Student ID: `STU001`
   - First Name: `John`
   - Last Name: `Doe`
   - Email: `john@example.com`
   - Phone: `555-1234`
5. Click **Add Student**
6. **Expected**: Success message + student appears in table
7. **Check Supabase**:
   - SQL Editor → Browse → **students** table
   - Should see: `STU001 - John Doe`

### Test 2.2: Record Grades
**Steps:**
1. Click **Grades** in sidebar
2. Select student: `STU001 - John Doe`
3. Enter grade: `85` (for a subject)
4. Click **Record Grade**
5. **Expected**: Success message
6. **Check Supabase**:
   - Browse → **grades** table
   - Should see: `STU001` with grade = `85`

### Test 2.3: Mark Attendance
**Steps:**
1. Click **Attendance** in sidebar
2. Select student: `STU001 - John Doe`
3. Select status: **Present**
4. Click **Mark**
5. **Expected**: Success message
6. **Check Supabase**:
   - Browse → **attendance** table
   - Should see: `STU001` with status = `Present`

---

## Test Suite 3: Cross-Device Sync (10 min)

### Test 3.1: Data Sync Between Sessions
**Steps:**
1. **Device A**: Login as admin
2. **Device A**: Add student `STU002 - Jane Smith`
3. **Device B**: Open a **new private/incognito window**
4. **Device B**: Go to `http://localhost:8000`
5. **Device B**: Login as admin (same account)
6. **Device B**: Click **Students**
7. **Expected**: Both `STU001` and `STU002` appear!

If this works: ✅ Cross-device sync is working!

### Test 3.2: Real-Time Updates
**Steps:**
1. **Device A**: Open admin dashboard
2. **Device B**: Open admin dashboard (same browser or different)
3. **Device A**: Add student `STU003`
4. **Device B**: Refresh page (F5)
5. **Expected**: `STU003` appears on Device B

---

## Test Suite 4: Offline Mode (5 min)

### Test 4.1: Add Data Offline
**Steps:**
1. Open DevTools (F12)
2. Go to **Application** tab
3. Click **Offline** (simulate offline)
4. Try to add student `STU004 - Offline User`
5. Click **Add Student**
6. **Expected**: Success message (should work offline)
7. **Check localStorage**:
   - Still in DevTools → Storage → LocalStorage
   - Should see students array with `STU004`

### Test 4.2: Auto-Sync When Online
**Steps:**
1. Go back to online (uncheck Offline in DevTools)
2. Wait 5 seconds
3. **Check Supabase**:
   - Browse → **students** table
   - Should now see: `STU004`
4. **Expected**: Offline data synced to cloud!

---

## Test Suite 5: Security & Permissions (10 min)

### Test 5.1: Student Can't See Other Students' Grades
**Steps:**
1. Create 2 student accounts:
   - `student1@example.com`
   - `student2@example.com`
2. Login as admin, record grades for both
3. Login as `student1@example.com`
4. Click **Grades** tab
5. **Expected**: Only sees their OWN grades, not student2's
6. **If fails**: RLS policy is broken ⚠️

### Test 5.2: Teacher Sees Only Their Students
**Steps:**
1. Create teacher account: `teacher@example.com`
2. Create 2 students: `STU005`, `STU006`
3. Assign both to teacher (in admin panel)
4. Login as teacher
5. Click **Students**
6. **Expected**: Only sees their assigned students
7. **If shows all**: RLS policy is broken ⚠️

---

## Test Suite 6: Error Handling (5 min)

### Test 6.1: Duplicate Email
**Steps:**
1. Go to Registration
2. Try to register `test@example.com` again (already exists)
3. **Expected**: Error message: "Email already registered"

### Test 6.2: Invalid Email
**Steps:**
1. Go to Registration
2. Try to register `notanemail`
3. **Expected**: Error message: "Invalid email format"

### Test 6.3: Weak Password
**Steps:**
1. Go to Registration
2. Password: `123` (less than 6 characters)
3. **Expected**: Error message: "Password must be at least 6 characters"

---

## Test Checklist - Mark Results

| Test | Pass | Fail | Notes |
|------|------|------|-------|
| 1.1 Registration | ⬜ | ⬜ | |
| 1.2 Login | ⬜ | ⬜ | |
| 2.1 Add Student | ⬜ | ⬜ | |
| 2.2 Record Grade | ⬜ | ⬜ | |
| 2.3 Mark Attendance | ⬜ | ⬜ | |
| 3.1 Cross-Device Sync | ⬜ | ⬜ | |
| 3.2 Real-Time Updates | ⬜ | ⬜ | |
| 4.1 Offline Add | ⬜ | ⬜ | |
| 4.2 Auto-Sync Online | ⬜ | ⬜ | |
| 5.1 Student Privacy | ⬜ | ⬜ | |
| 5.2 Teacher Visibility | ⬜ | ⬜ | |
| 6.1 Duplicate Email | ⬜ | ⬜ | |
| 6.2 Invalid Email | ⬜ | ⬜ | |
| 6.3 Weak Password | ⬜ | ⬜ | |

---

## ✅ Expected Results Summary

After completing all tests, you should see:

### ✅ Working Features
- [x] Registration with email validation
- [x] Login with session persistence
- [x] Students appear in Supabase
- [x] Grades sync to cloud
- [x] Attendance syncs to cloud
- [x] Cross-device access works
- [x] Offline mode works
- [x] Auto-sync when online
- [x] Privacy controls work
- [x] Error messages appear

### ⚠️ Known Limitations (For Now)
- ❌ Session doesn't auto-recover on page refresh
- ❌ Edge function not configured
- ❌ Not deployed to production
- ❌ Mobile layout not optimized
- ❌ No password reset

---

## 🐛 Troubleshooting

### Problem: "Can't connect to Supabase"
**Solution**: 
- Check `.env` file has correct SUPABASE_URL
- Check SUPABASE_ANON_KEY is correct
- Check internet connection
- Check Supabase project is active

### Problem: "Data doesn't appear in Supabase"
**Solution**:
- Check browser console (F12) for errors
- Verify RLS policies aren't blocking writes
- Check that you're logged in as admin
- Wait 5 seconds for sync to complete

### Problem: "Can't register with email"
**Solution**:
- Check email format is valid (has @)
- Check email isn't already registered
- Check Supabase Auth isn't rate-limiting

### Problem: "Offline mode doesn't work"
**Solution**:
- Check localStorage is enabled in browser
- Check DevTools → Application tab
- Check localStorage quota isn't full

---

## 📝 Notes

- Use **private/incognito windows** to test cross-device without clearing cookies
- Open **DevTools (F12)** to see detailed error messages
- **Refresh page (F5)** after adding data to see if it persists
- Check **Supabase Dashboard** to verify cloud sync
- Use **Ctrl+Shift+Delete** to clear localStorage between tests if needed

---

## 🎯 Next Steps After Testing

1. **If all tests pass**: Move to STEP 3 - Deploy
2. **If tests fail**: Debug issues before deploying
3. **Keep this guide**: Use for production testing

