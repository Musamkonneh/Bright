Supabase setup & integration guide

1) Create a Supabase project
   - Go to https://app.supabase.com and create a new project.
   - Note SUPABASE_URL and the anon/public key.
   - In Settings -> API, copy the SERVICE_ROLE key (keep this secret.)

2) Apply schema
   - Open SQL Editor in Supabase and paste the contents of `supabase-sql/schema.sql`.
   - Run the SQL to create tables.

3) Update index.html
   - Replace 'REPLACE_WITH_SUPABASE_URL' with your SUPABASE_URL.
   - Replace 'REPLACE_WITH_SUPABASE_ANON_KEY' with your SUPABASE_ANON_KEY.

4) Create a Storage bucket
   - Go to Storage -> Buckets -> New bucket
   - Name: `photos` (public if you want simple public URLs, or private with signed URLs)

5) Deploy the Edge Function for admin user creation
   - In the Supabase project, go to Functions -> New Function -> Deploy from code
   - Use the code in `functions/create-user/index.ts`.
   - Set environment variables for the function: SUPABASE_URL and SUPABASE_SERVICE_ROLE_KEY.
   - Deploy and note the function URL (e.g. https://<project>.functions.supabase.co/create-user)

6) Front-end integration
   - The supabase-js is already included via CDN in index.html.
   - Use `frontend/supabase-snippets.md` as a reference for additional helpers.
   - Replace admin-create-account client-side flows to call the edge function (do NOT expose service_role key to clients).

7) Running admin scripts locally
   - Install dependencies: npm install
   - To run `scripts/admin_create_user.js` or `scripts/import_demo.js`, use PowerShell with environment variables:
     $env:SUPABASE_URL = 'https://your.supabase.co'; $env:SUPABASE_SERVICE_ROLE_KEY = 'service-role-key'; node scripts\admin_create_user.js '{"email":"x@x.com","password":"Pass1234!","role":"teacher","full_name":"Fatima"}'

8) Security notes
   - Never expose SUPABASE_SERVICE_ROLE_KEY in client code or public repos.
   - Use Edge Functions (or server-side) to perform privileged operations.

9) Next steps (suggested)
   - Create an admin user using the edge function or script.
   - Migrate existing localStorage data into Supabase using `scripts/import_demo.js` (edit the demo arrays and run it with service_role key).
   - Users can now log in from any device and access their accounts persistently.

