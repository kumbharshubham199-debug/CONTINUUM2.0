# CONTINUUM — Manual QA Checklist

Run these checks in a modern browser (preferably a fresh browser profile) before submission. Mark a test complete only after performing it yourself.

## Navigation and layout
- [ ] Login screen opens and enters the dashboard.
- [ ] Sidebar links open all six modules and Settings & Data.
- [ ] Dashboard retains its original eight operational metrics, workflow, attention alerts and quick actions.
- [ ] Layout remains usable on desktop and mobile widths.
- [ ] Warm Neutral palette and continuous-loop logo appear consistently.

## Existing manufacturing workflow
- [ ] Add, edit, search and delete an inventory item.
- [ ] Add stock and use stock; stock cannot be reduced below zero.
- [ ] Create a production plan.
- [ ] Create a production run linked to the plan.
- [ ] Verify planned 500 and actual 350 gives loss 150.
- [ ] Verify actual output above plan is shown as overproduction, not negative loss.
- [ ] Add a machine and record a breakdown.
- [ ] Verify a machine under maintenance cannot be selected for a new production run.
- [ ] Mark a breakdown repaired and verify the historical breakdown / production-loss record remains.
- [ ] Record a quality check; accepted + rejected cannot exceed inspected quantity.
- [ ] Record process stages and final inspection.
- [ ] Dispatch is available only after passed quality and passed final inspection.
- [ ] Dispatch quantity cannot exceed approved accepted quantity or production output.

## Analytics & Updates
- [ ] Add records in at least two modules and verify the pie chart distribution changes.
- [ ] Verify the activity trend reflects real action dates.
- [ ] Verify created vs updated counts change after editing an existing record.
- [ ] Filter by date range and individual module.
- [ ] Verify the recent activity feed shows actor, action and timestamp for new activity.
- [ ] Confirm an empty dataset displays empty states rather than sample values.

## Backup and offline
- [ ] Export all data to JSON.
- [ ] Import a valid backup and verify records / relationships.
- [ ] Try an invalid JSON file and verify existing records remain unchanged.
- [ ] Verify the service worker caches the static app shell when hosted on HTTPS or localhost.
- [ ] After first successful load, reopen the app offline and verify the shell opens on the same browser/device.
- [ ] Remember: local browser data is not cloud-synced; test JSON transfer separately if moving devices.

## Role-based access checks
- [ ] Administrator sees all six modules and Settings & Data; can add/edit/delete records.
- [ ] Manager sees all six modules; can add/edit records but cannot delete or access Settings & Data.
- [ ] Inventory Staff sees Inventory only (plus Dashboard); can add/edit inventory but cannot access other modules or delete records.
- [ ] Production Staff sees Planning and Production only (plus Dashboard); can add/edit those modules but cannot delete records.
- [ ] Quality Staff sees Quality and Process & Inspection only (plus Dashboard); can add/edit those modules but cannot delete records.
- [ ] Dispatch Staff sees Dispatch only (plus Dashboard); can add/edit dispatch but cannot delete records.
- [ ] Directly entering a restricted module URL shows an access-restricted screen.
- [ ] Confirm each role is tested with a separate authenticated account. Browser UI restrictions alone are not a security boundary for LocalStorage data.

## Supabase security setup
- [ ] Run `supabase-schema.sql` in Supabase SQL Editor (already done for the current project).
- [ ] Run the updated `supabase-role-security-migration.sql` after the initial schema (also updates the allowed role list).
- [ ] Verify each staff role can read/write only its assigned cloud module(s), and cannot delete records.
- [ ] Verify Manager can read/write all modules but cannot delete records.
- [ ] Verify Administrator can manage all module records and delete records.
- [ ] Verify non-admin users cannot insert/update/delete workspace memberships.
- [ ] Test email confirmation and sign-in using the final GitHub Pages URL after setting Supabase Site URL and Redirect URLs.

## Important scope check
- [ ] Do not describe demo login / role picker as secure authentication.
- [ ] Do not describe multi-company cloud sync, email notifications or realtime sync as active until a real backend is configured and tested.
