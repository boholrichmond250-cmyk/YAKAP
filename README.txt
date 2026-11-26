YAKAP CLAIM SYSTEM - ONLINE VERSION (no claude.ai sign-in needed)
==================================================================
Files:  index.html (the system)   setup.sql (the database)

STEP 1  Create a free account at https://supabase.com and click "New project".
STEP 2  Open SQL Editor > New query. Paste ALL of setup.sql. Click Run.
        ("Success. No rows returned" = correct.)
STEP 3  (Recommended) Authentication > Sign In / Providers > Email:
        turn OFF "Confirm email", then Save.
STEP 4  Project Settings (gear) > Data API / API Keys. Copy:
          - Project URL        (https://xxxx.supabase.co)
          - anon public key    (starts with eyJ...)  or "Publishable key"
        Do NOT use the secret / service_role key.
STEP 5  Open index.html in Notepad. Near the top replace:
          PASTE_YOUR_SUPABASE_URL_HERE       with your Project URL
          PASTE_YOUR_SUPABASE_ANON_KEY_HERE  with your key
        Keep the quotation marks. Save.
STEP 6  Go to https://app.netlify.com/drop and drag the folder that contains
        index.html. Netlify gives you a public link.
STEP 7  Supabase > Authentication > URL Configuration: set "Site URL" to
        your Netlify link (needed for password reset emails).

FIRST ACCOUNT = ADMINISTRATOR
  Open  YOUR-LINK/#signup  (example: https://mysite.netlify.app/#signup)
  and create your account FIRST. It becomes the Administrator.
  Give the same #signup link to personnel so they can create their own
  accounts (they are View only). The Administrator can change roles in
  Profile.

WHAT EACH ROLE CAN DO
  Administrator: add / delete entries, add Error/Denied, delete all data,
                 manage roles and accounts, export CSV.
  Personnel:     view dashboard, output, Error/Denied, export CSV.

FORGOT PASSWORD: the user types their Gmail on the login screen; Supabase
emails a reset link. (Free Supabase email has a low hourly limit.)
