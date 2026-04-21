@echo off
cd /d "c:\Users\Konneh\Desktop\SCHOOL MANAGEMENT"
set SUPABASE_URL=https://zvmftgptxrpkgvvmivtr.supabase.co
set SUPABASE_SERVICE_ROLE_KEY=sb_secret_CMvzJzEi1-bTmxZ_x8HTJw_wGSmzzZU
node scripts\admin_create_user.js "{\"email\":\"admin@school.com\",\"password\":\"Admin123!\",\"role\":\"admin\",\"full_name\":\"Administrator\"}"
pause