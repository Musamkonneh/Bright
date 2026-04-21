# Technical Architecture: Supabase Integration

## System Overview

```
┌─────────────────────────────────────────────────────────────────┐
│                    School Management System                      │
│                        (index.html)                              │
│                                                                   │
│  ┌──────────────────┐         ┌──────────────────┐             │
│  │  Local Storage   │         │  Supabase Cloud  │             │
│  │  (Offline Mode)  │◄─────►  │   (Primary DB)   │             │
│  └──────────────────┘         └──────────────────┘             │
│                                                                   │
│  ┌─────────────────────────────────────────────────────────┐   │
│  │           Supabase JavaScript Client                     │   │
│  │  - Authentication (login/register)                       │   │
│  │  - Database queries (CRUD operations)                    │   │
│  │  - Session management                                    │   │
│  └─────────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────────┘
```

## Data Flow Architecture

### 1. Registration Flow

```
User clicks Register
    ↓
Validates form (client-side)
    ↓
supabaseClient.auth.signUp({email, password, options: {data: {role, full_name}}})
    ↓
Supabase Auth Service creates user
    ↓
Database Trigger: handle_new_user() fires
    ↓
CREATE profile record with id, email, role
    ↓
Application:
  - Updates profile with correct email/role
  - Creates student or teacher record
  - Saves to localStorage
    ↓
User Success Message
```

### 2. Login Flow

```
User clicks Login
    ↓
Validates form (client-side)
    ↓
supabaseClient.auth.signInWithPassword({email, password})
    ↓
Supabase Auth validates credentials
    ↓
Returns: user object + auth tokens
    ↓
Application:
  - Queries profiles table for user.id
  - Queries students/teachers table for profile_id
  - Sets document.body.className to role
  - Calls loadFromSupabase() to sync all data
  - Saves session to localStorage
    ↓
User dashboard loads
```

### 3. Session Recovery Flow

```
Page loads
    ↓
Check if Supabase is initialized
    ↓
Call supabaseClient.auth.getUser()
    ↓
If user exists:
  - Query profiles table
  - Query students/teachers table
  - Load all data from Supabase tables
  - Restore UI state
  - No login required!
    ↓
If no user:
  - Show login page
```

### 4. Data Sync Flow (Example: Adding Student)

```
Admin submits student form
    ↓
Create Auth User (optional, via Edge Function)
    ↓
Create users array entry
    ↓
Create students array entry
    ↓
Save to localStorage
    ↓
Call syncStudentsToSupabase()
    ↓
For each student:
  - If new: INSERT into students table
  - If existing: UPDATE students table
    ↓
Sync complete
    ↓
✅ Data now in both localStorage and Supabase
```

## Database Schema

### profiles table
```sql
├── id (UUID, PK, FK from auth.users)
├── email (TEXT, UNIQUE)
├── role (TEXT: admin|teacher|student)
├── full_name (TEXT)
├── created_at (TIMESTAMP)
└── updated_at (TIMESTAMP)

RLS Policies:
- Users can view their own profile
- Users can update their own profile
- Admins can view/update all profiles
```

### students table
```sql
├── id (UUID, PK)
├── profile_id (UUID, FK from profiles)
├── student_id (TEXT, UNIQUE)
├── first_name (TEXT)
├── last_name (TEXT)
├── date_of_birth (DATE)
├── gender (TEXT)
├── address (TEXT)
├── phone (TEXT)
├── email (TEXT)
├── enrollment_date (DATE)
├── created_at (TIMESTAMP)
└── updated_at (TIMESTAMP)

RLS Policies:
- Teachers/Admins can view students
- Admins can insert/update/delete
```

### teachers table
```sql
├── id (UUID, PK)
├── profile_id (UUID, FK from profiles)
├── id_number (TEXT, UNIQUE)
├── first_name (TEXT)
├── last_name (TEXT)
├── email (TEXT)
├── subjects (JSONB array)
├── hire_date (DATE)
├── created_at (TIMESTAMP)
└── updated_at (TIMESTAMP)

RLS Policies:
- Teachers/Admins can view teachers
- Admins can insert/update/delete
```

### classes table
```sql
├── id (UUID, PK)
├── name (TEXT)
├── teacher_id (UUID, FK from teachers)
├── student_ids (JSONB array)
├── created_at (TIMESTAMP)
└── updated_at (TIMESTAMP)
```

### grades table
```sql
├── id (UUID, PK)
├── student_id (UUID, FK from students)
├── class_id (UUID, FK from classes)
├── subject (TEXT)
├── grade (DECIMAL/TEXT)
├── period (TEXT)
├── date (DATE)
├── created_at (TIMESTAMP)
└── updated_at (TIMESTAMP)
```

### attendance table
```sql
├── id (UUID, PK)
├── student_id (UUID, FK from students)
├── class_id (UUID, FK from classes)
├── attendance_date (DATE)
├── status (TEXT: Present|Absent|Late|Excused)
├── notes (TEXT)
├── created_at (TIMESTAMP)
└── updated_at (TIMESTAMP)
```

## Sync Functions

### syncStudentsToSupabase()
```javascript
Purpose: Upload all student records to Supabase
Triggers: After adding/editing student
Process:
  1. For each student in local students array
  2. If ID exists: UPDATE student record
  3. If new: INSERT student record
  4. Handle errors gracefully (don't break app)
```

### syncTeachersToSupabase()
```javascript
Purpose: Upload all teacher records to Supabase
Triggers: After adding/editing teacher
Process:
  1. For each teacher in local teachers array
  2. Format subjects as array
  3. INSERT or UPDATE in teachers table
```

### syncGradesToSupabase()
```javascript
Purpose: Upload all grade records to Supabase
Triggers: After recording grades
Process:
  1. For each grade in local grades array
  2. UPSERT (insert or update) based on unique combo
  3. Sync by student_id, class_id, subject, period
```

### syncAttendanceToSupabase()
```javascript
Purpose: Upload all attendance records to Supabase
Triggers: After marking attendance
Process:
  1. For each attendance date/class combination
  2. For each student record in that attendance
  3. UPSERT attendance record with status
```

### loadFromSupabase()
```javascript
Purpose: Load all data from Supabase into app
Triggers: On page load (if logged in), on login
Process:
  1. Query students table → populate students array
  2. Query teachers table → populate teachers array
  3. Query classes table → populate classes array
  4. Query grades table → populate grades array
  5. Query attendance table → populate attendance array
  6. Save everything to localStorage
  7. App now has all cloud data
```

## Security Architecture

### Authentication
- Supabase handles password hashing (bcrypt)
- Email verification (optional)
- Session tokens stored securely
- Auto-refresh tokens

### Row Level Security (RLS)
- All tables have RLS enabled
- Policies enforce data access rules
- Students can only see their own data
- Teachers can see their student's data
- Admins can see all data

### API Keys
- Public Key (Anon Key): Used by app
  - Limited permissions
  - Can only see/modify authorized data via RLS
- Service Role Key: Kept secret
  - Used for admin operations
  - Not exposed in client code

### HTTPS
- All data in transit is encrypted
- Supabase enforces HTTPS

## Error Handling

### Registration Errors
```javascript
try {
  supabaseClient.auth.signUp(...)
} catch (err) {
  // Show user-friendly error
  // Log to console for debugging
  // Fallback to local registration
}
```

### Sync Errors
```javascript
syncStudentsToSupabase().catch(e => {
  console.warn('Sync failed', e)
  // App continues working with local data
  // Retry on next interaction
})
```

### Connection Errors
```javascript
if (!supabaseClient) {
  // Use local storage only
  // App continues working offline
}
```

## Performance Optimization

### Lazy Loading
- Data loaded only when needed
- Sync happens asynchronously
- UI updates immediately (optimistic)

### Caching
- localStorage caches all data
- Reduces network requests
- Works offline seamlessly

### Batch Operations
- Grades/attendance sync in batches
- Reduces database round trips

## Offline Mode

### How It Works
1. All data cached in localStorage
2. User can continue working offline
3. Changes saved to localStorage immediately
4. When online: sync functions push changes to Supabase

### Sync on Reconnect
```javascript
// Automatic when data changes
if (navigator.onLine) {
  syncStudentsToSupabase()
  syncTeachersToSupabase()
  syncGradesToSupabase()
  syncAttendanceToSupabase()
}
```

## Scalability Considerations

### Current Setup
- Suitable for 100-1000 users
- Real-time features not yet implemented
- Data loaded on login

### For Growth
- Implement pagination
- Add real-time subscriptions
- Use database views for complex queries
- Add caching layer (Redis)
- Implement background jobs

## Debugging

### Enable Console Logging
```javascript
// Browser console shows:
"Supabase client initialized"
"Loaded data from Supabase"
"Synced students to Supabase"
```

### Check Network Tab
- Network → Supabase API calls
- Look for POST/GET/PATCH requests
- Check response status (200 = success)

### Check Supabase Logs
- Supabase Dashboard → Logs
- Shows all database operations
- Errors and success messages

## Future Enhancements

1. **Real-time Sync** - WebSocket subscriptions
2. **Offline Persistence** - Service workers
3. **Push Notifications** - Grade and attendance alerts
4. **File Storage** - Document uploads
5. **Advanced Queries** - Search and filtering
6. **Analytics** - Usage tracking
7. **Backup & Export** - Data portability

---

**This architecture ensures data persistence, cross-device access, and offline capability while maintaining security and performance.**
