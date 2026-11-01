# CONTINUUM — Integrated Manufacturing Process Management System

**Warm Neutral Edition · Academic project build**  
*A continuous flow for smarter manufacturing.*

CONTINUUM is a browser-based manufacturing workflow system built with HTML, CSS and vanilla JavaScript, with Supabase email authentication and company-workspace bootstrap.

## Run locally

1. Extract the ZIP.
2. Serve the folder with VS Code Live Server or another static HTTPS/localhost server.
3. Open `login.html`.
4. Register a company with a name, full name, email and password, or sign in to an existing account.
5. Confirm the email if Supabase requests it, then return to the same deployment and sign in.

Do not open the site with `file://`. The Supabase JS client is loaded from a CDN and requires an internet connection for authentication.

## Supabase configuration

`supabase-config.js` contains the project URL and the Supabase **publishable** key. A publishable key is intended for browser use. Never put a Supabase secret/service-role key or database password in frontend files.

The database foundation is installed separately in Supabase SQL Editor. The initial schema is in `supabase-schema.sql`. After it, run `supabase-role-security-migration.sql` to enforce module-level read/write permissions (Administrator and Manager: all six modules; Inventory Staff: inventory; Production Staff: planning/production; Quality Staff: quality/inspection; Dispatch Staff: dispatch). Only Administrator can delete manufacturing records or access Settings & Data. Configure Authentication → URL Configuration only after the final GitHub Pages URL is known:

- Site URL: the final GitHub Pages root URL.
- Redirect URL: the final `login.html` URL.

Email confirmation is enabled. A newly registered user creates a workspace and becomes its first Administrator when signing in after confirmation.

## Modules and workflow

1. Inventory
2. Planning
3. Production (includes machine management, maintenance and breakdown history)
4. Quality
5. Process & Inspection
6. Dispatch

**Workflow:** Inventory → Planning → Production → Quality → Process & Inspection → Dispatch.

The Dashboard retains the operational overview and includes **Analytics & Updates**:

- Module-wise activity distribution (pie chart)
- Daily activity trend (bar chart)
- Created vs updated actions by module
- Date-range and module filters
- Recent activity feed with actor, action and timestamp

Charts use actual activity records; they do not use generated sample data.

## Current implementation status

- Warm Neutral theme: beige, warm grey and olive.
- Approved CONTINUUM infinity-loop logo lockup on the login screen and matching infinity mark in the workspace sidebar. Logo assets are stored locally in the project (`continuum-logo-lockup.jpg`, `continuum-infinity-mark.jpg`).
- Responsive layout for desktop and mobile.
- Existing six modules and local business rules retained.
- Supabase email sign-up/sign-in and workspace creation through the `create_workspace` database function.
- Workspace membership lookup on authenticated entry.
- Company name and user name retained in Supabase signup metadata.
- Role-based navigation and page access for Administrator, Manager and four staff roles.
- Role-security SQL migration restricts cloud record reads/writes by module; only Administrator can delete cloud records. Activity history remains append-only.
- Manual cloud backup/restore of six module snapshots from Settings & Data.
- Local JSON export and validated import.
- Static app-shell caching for offline reopening after first successful online load.

## Important limitations — read before submission

This is an **academic project build, not a production-ready SaaS ERP**.

- Manufacturing records continue to be stored locally by default. The Settings page provides a manual cloud snapshot upload/restore tool; automatic real-time sync, IndexedDB offline queue and conflict resolution are not implemented yet.
- Employee invitation/deactivation and in-app role assignment are not implemented. Create/authenticate staff accounts separately and assign their `workspace_members.role` through a trusted Supabase administrator workflow. Never expose a service-role key in browser code. Run the role-security migration and test each role before using real company data.
- Role-based controls in the browser govern page navigation and actions, but manufacturing data is still stored in shared browser LocalStorage. This is not a secure multi-user data boundary. The Supabase migration protects cloud `manufacturing_records`; full multi-user operation requires moving module records to server-backed storage and testing it end-to-end.
- Browser/email notifications and scheduled digests are not implemented.
- Automated workflows and employee invitations are not implemented.
- The service worker caches the app shell; it does not synchronize records offline.
- The current manual cloud backup is a six-part workspace snapshot, not per-record continuous sync. Use one designated Admin to upload the authoritative snapshot; concurrent snapshot uploads can overwrite one another.
- Manual cloud restore replaces the current browser's records. Export a JSON backup first.
- Use synthetic/classroom data until full security and browser testing is complete.

## Files

- `app.js` — module logic, dashboard analytics, authentication and manual cloud snapshot operations.
- `style.css` — shared responsive UI and Warm Neutral theme.
- `supabase-config.js` — public project URL and publishable key.
- `supabase-schema.sql` — initial database foundation.
- `supabase-role-security-migration.sql` — role-based read/write authorization hardening; run after the initial schema.
- `ROLE_ACCESS_GUIDE.md` — role definitions, assignment guidance and testing notes.
- `sw.js` / `manifest.webmanifest` — static offline cache and install metadata.
- `QA_CHECKLIST.md` — manual functional test checklist.
- `CLOUD_BACKEND_PLAN.md` — remaining cloud work and limitations.

Complete `QA_CHECKLIST.md` in a fresh browser profile before submission. Only mark features complete after actually testing them.


## Source language notes
The application UI is delivered as HTML page shells, CSS styling, and browser JavaScript. Supabase SQL files are setup/migration scripts only; they are marked non-detectable in GitHub language statistics with `.gitattributes` so they do not misleadingly dominate the app's language chart. The SQL files remain included and must still be run in Supabase when setting up the backend. GitHub's language chart measures file contents, not runtime architecture.
