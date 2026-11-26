-- ============================================================
-- YAKAP Claim System - copy of your CURRENT data (from the claude.ai version)
-- Run ONCE, AFTER setup.sql: Supabase > SQL Editor > New query > paste > Run
-- Running it twice would add the same rows twice.
-- ============================================================

insert into public.claims (year, month, month_to, registered, transmitted, returned, denied, errs, net) values
 (2026, 0, 2,    531, 359, 0, 0, 0, 244120),   -- Jan - Mar
 (2026, 3, 4,    153,  57, 0, 0, 0,  38760),   -- Apr - May
 (2026, 5, null,  72,  21, 0, 0, 0,  14280),   -- Jun
 (2026, 6, null, 145,  56, 0, 0, 0,  38080),   -- Jul
 (2026, 7, null, 219, 167, 0, 0, 0, 113560),   -- Aug
 (2026, 8, null, 379,  85, 0, 0, 0,  57800),   -- Sep
 (2026, 9, null, 120,  81, 0, 0, 0,  55080);   -- Oct

insert into public.error_denied (year, month, month_to, kind, n) values
 (2026, 0, 8, 'error', 60);                    -- Error: Jan - Sep

-- Check after running: Registered 1,619 | Transmitted 826 | Net amount 561,680.00 | Error 60
