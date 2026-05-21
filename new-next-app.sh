#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title New Next.js App
# @raycast.mode fullOutput

# Optional parameters:
# @raycast.icon 🚀
# @raycast.argument1 { "type": "text", "placeholder": "project-name" }

# Documentation:
# @raycast.description Scaffolds a professional Next.js reference project — use this as a blueprint while building in nnab

set -e

# ============================================================================
# new-next-app.sh
# Professional reference project — not for building in, but for learning from.
# Every folder, file, and pattern reflects real-world best practices.
# Usage: bash new-next-app.sh <project-name>
# ============================================================================

# -----------------------------
# Validate input
# -----------------------------

if [ -z "$1" ]; then
  echo "❌ Usage: bash new-next-app.sh <project-name>"
  exit 1
fi

PROJECT_NAME="$1"
TARGET="$HOME/Code/$PROJECT_NAME"

if [ -d "$TARGET" ]; then
  echo "❌ '$TARGET' already exists — choose a different name"
  exit 1
fi

echo ""
echo "🚀 Creating Next.js reference project: $PROJECT_NAME"
echo "📍 Location: $TARGET"
echo ""

# -----------------------------
# Create Next.js app
# -----------------------------

echo "⚙️  Running create-next-app..."
npx create-next-app@latest "$TARGET" \
  --typescript \
  --tailwind \
  --eslint \
  --app \
  --src-dir \
  --import-alias "@/*" \
  --yes

cd "$TARGET"

# -----------------------------
# Install extra dependencies
# -----------------------------

echo ""
echo "📦 Installing extra dependencies..."
npm install next-themes
echo "  ✅ next-themes (dark/light mode)"

# -----------------------------
# Scaffold folder structure
# -----------------------------

echo ""
echo "📁 Creating folder structure..."

mkdir -p src/app/\(auth\)/login
mkdir -p src/app/\(dashboard\)/dashboard
mkdir -p src/app/api/tasks
mkdir -p src/components/features/tasks
mkdir -p src/components/shared
mkdir -p src/components/layout
mkdir -p src/hooks
mkdir -p src/services
mkdir -p src/lib/api
mkdir -p src/types
mkdir -p src/context
mkdir -p src/config
mkdir -p src/utils
mkdir -p src/mocks
mkdir -p src/constants
mkdir -p src/stores
mkdir -p docs

echo "  ✅ All folders created"

# ============================================================================
# APP SHELL
# ============================================================================

echo ""
echo "🏗️  Scaffolding app shell..."

cat > src/app/layout.tsx << 'LAYOUT'
// ─── Root Layout ─────────────────────────────────────────────────────────────
// Every page in the app goes through this layout.
// This is where you add things that wrap the ENTIRE app:
//   - Fonts
//   - Global providers (ThemeProvider, AuthProvider, etc.)
//   - Global metadata
//
// Rule: keep this file minimal. Move providers to src/context/ and import them here.

import type { Metadata } from 'next';
import { Geist } from 'next/font/google';
import { ThemeProvider } from '@/context/ThemeProvider';
import { cn } from '@/lib/utils';
import './globals.css';

const geist = Geist({ subsets: ['latin'], variable: '--font-geist' });

export const metadata: Metadata = {
  title: {
    default: 'App',
    // template means child pages can set just their own name e.g. "Dashboard"
    // and the full title becomes "Dashboard | App"
    template: '%s | App',
  },
  description: '',
};

export default function RootLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <html lang="en" suppressHydrationWarning>
      <body className={cn('min-h-screen bg-background font-sans antialiased', geist.variable)}>
        {/* ThemeProvider enables dark/light mode via next-themes */}
        <ThemeProvider>{children}</ThemeProvider>
      </body>
    </html>
  );
}
LAYOUT
echo "  ✅ src/app/layout.tsx"

cat > src/app/page.tsx << 'PAGE'
// ─── Root Page (/) ───────────────────────────────────────────────────────────
// In most real apps this either:
//   a) Redirects to /dashboard if the user is logged in
//   b) Redirects to /login if not
//   c) Shows a marketing/landing page
//
// For now it's a simple placeholder. In a real app you'd use:
//   import { redirect } from 'next/navigation';
//   redirect('/dashboard');

export default function Home() {
  return (
    <main className="min-h-screen flex items-center justify-center">
      <p className="text-sm text-muted-foreground">Root page — redirect to /dashboard or /login here.</p>
    </main>
  );
}
PAGE
echo "  ✅ src/app/page.tsx"

cat > src/app/loading.tsx << 'ROOTLOADING'
// ─── Root Loading ─────────────────────────────────────────────────────────────
// Next.js shows this automatically while any page in the app is loading.
// You can override this with a more specific loading.tsx inside any route folder.

import LoadingSpinner from '@/components/shared/LoadingSpinner';

export default function Loading() {
  return (
    <div className="min-h-screen flex items-center justify-center">
      <LoadingSpinner />
    </div>
  );
}
ROOTLOADING
echo "  ✅ src/app/loading.tsx"

cat > src/app/not-found.tsx << 'NOTFOUND'
// ─── 404 Page ────────────────────────────────────────────────────────────────
// Next.js renders this automatically for any route that doesn't exist.
// You only need one of these at the app root — it catches all unmatched routes.

import Link from 'next/link';

export default function NotFound() {
  return (
    <main className="min-h-screen flex flex-col items-center justify-center gap-4">
      <h1 className="text-2xl font-semibold tracking-tight">Page not found</h1>
      <p className="text-sm text-muted-foreground">
        The page you&apos;re looking for doesn&apos;t exist.
      </p>
      <Link href="/" className="text-sm underline underline-offset-4 hover:text-foreground">
        Go home
      </Link>
    </main>
  );
}
NOTFOUND
echo "  ✅ src/app/not-found.tsx"

cat > src/app/error.tsx << 'ROOTERROR'
// ─── Root Error Boundary ──────────────────────────────────────────────────────
// Next.js renders this if ANY page in the app throws an unhandled error.
// Completes the trio: loading.tsx + not-found.tsx + error.tsx
//
// Must be 'use client' — that's a Next.js requirement for error boundaries.
// `reset` retries rendering the page. Always log the error somewhere (Sentry, etc.)
//
// Note: this only catches RUNTIME errors. 404s go to not-found.tsx.

'use client';

import { useEffect } from 'react';

export default function GlobalError({
  error,
  reset,
}: {
  error: Error & { digest?: string };
  reset: () => void;
}) {
  useEffect(() => {
    // Real app: Sentry.captureException(error);
    console.error(error);
  }, [error]);

  return (
    <main className="min-h-screen flex flex-col items-center justify-center gap-4">
      <h1 className="text-2xl font-semibold tracking-tight">Something went wrong</h1>
      <p className="text-sm text-muted-foreground">An unexpected error occurred.</p>
      <button
        onClick={reset}
        className="text-sm underline underline-offset-4 hover:text-foreground"
      >
        Try again
      </button>
    </main>
  );
}
ROOTERROR
echo "  ✅ src/app/error.tsx"

cat >> src/app/globals.css << 'CSS'

/* ─── Global Base Overrides ──────────────────────────────────────────────────
   Add app-wide CSS here that doesn't belong in a component.
   Keep this minimal — prefer Tailwind classes in components.
*/
@layer base {
  /* Buttons and interactive elements should always show a pointer cursor */
  button:not(:disabled),
  [role="button"]:not(:disabled) {
    cursor: pointer;
  }
}
CSS
echo "  ✅ src/app/globals.css"

# ============================================================================
# AUTH ROUTES
# ============================================================================

echo ""
echo "🔐 Scaffolding auth routes..."

cat > src/app/\(auth\)/login/page.tsx << 'LOGINPAGE'
// ─── Login Page ───────────────────────────────────────────────────────────────
// Route: /login
// The (auth) folder is a route group — it doesn't affect the URL.
// It just lets you share a layout across auth pages (login, register, forgot-password)
// without that layout affecting the rest of the app.
//
// In a real app this page would contain a form wired to your auth provider
// (NextAuth, Clerk, Supabase Auth, etc.)

import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card';

export default function LoginPage() {
  return (
    <main className="min-h-screen flex items-center justify-center bg-background p-4">
      <Card className="w-full max-w-sm">
        <CardHeader>
          <CardTitle className="text-xl">Sign in</CardTitle>
        </CardHeader>
        <CardContent>
          {/* Your login form component would go here */}
          {/* e.g. <LoginForm /> from src/components/features/auth/ */}
          <p className="text-sm text-muted-foreground">Login form goes here.</p>
        </CardContent>
      </Card>
    </main>
  );
}
LOGINPAGE
echo "  ✅ src/app/(auth)/login/page.tsx"

# ============================================================================
# DASHBOARD ROUTES
# ============================================================================

echo ""
echo "📊 Scaffolding dashboard routes..."

cat > src/app/\(dashboard\)/layout.tsx << 'DASHLAYOUT'
// ─── Dashboard Layout ─────────────────────────────────────────────────────────
// Shared layout for every route inside (dashboard).
// This is where you put things every dashboard page needs:
//   - Sidebar
//   - Top navigation bar
//   - Auth guard (redirect to /login if not authenticated)
//
// The (dashboard) route group means this layout doesn't affect the URL.
// /dashboard, /settings, /profile all share this layout automatically.

import Navbar from '@/components/layout/Navbar';
import Sidebar from '@/components/layout/Sidebar';

export default function DashboardLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <div className="min-h-screen bg-background flex flex-col">
      <Navbar />
      <div className="flex flex-1">
        <Sidebar />
        {/* Main content area — each page renders here */}
        <main className="flex-1 overflow-y-auto">
          {children}
        </main>
      </div>
    </div>
  );
}
DASHLAYOUT
echo "  ✅ src/app/(dashboard)/layout.tsx"

cat > src/app/\(dashboard\)/dashboard/page.tsx << 'DASHPAGE'
// ─── Dashboard Page ───────────────────────────────────────────────────────────
// Route: /dashboard
// Routing only — this file does nothing except point to the View component.
//
// Why keep pages this lean?
//   - Separation of concerns: routing is Next.js's job, layout is the View's job
//   - The View can be tested and reused without the Next.js routing layer
//   - Consistent pattern across all pages — you always know pages are thin
//
// If you need to fetch data server-side, do it here and pass it as props:
//   const tasks = await tasksService.getAll();
//   return <DashboardView tasks={tasks} />;

import DashboardView from '@/components/features/dashboard/DashboardView';

export default function DashboardPage() {
  return <DashboardView />;
}
DASHPAGE
echo "  ✅ src/app/(dashboard)/dashboard/page.tsx"

cat > src/app/\(dashboard\)/dashboard/loading.tsx << 'DASHLOADING'
// ─── Dashboard Loading ────────────────────────────────────────────────────────
// Next.js shows this automatically while dashboard/page.tsx is loading.
// Because this file is inside the dashboard folder, it only applies here —
// it won't affect other routes.

import LoadingSpinner from '@/components/shared/LoadingSpinner';

export default function Loading() {
  return (
    <div className="flex items-center justify-center p-12">
      <LoadingSpinner />
    </div>
  );
}
DASHLOADING
echo "  ✅ src/app/(dashboard)/dashboard/loading.tsx"

cat > src/app/\(dashboard\)/dashboard/error.tsx << 'DASHERROR'
// ─── Dashboard Error Boundary ─────────────────────────────────────────────────
// Next.js renders this automatically if dashboard/page.tsx throws an error.
// Must be a Client Component ('use client') — that's a Next.js requirement.
//
// `reset` is a function Next.js gives you to retry rendering the page.
// Always log the error (to Sentry or console) inside useEffect.

'use client';

import { useEffect } from 'react';
import { Button } from '@/components/ui/button';

interface ErrorProps {
  error: Error & { digest?: string };
  reset: () => void;
}

export default function Error({ error, reset }: ErrorProps) {
  useEffect(() => {
    // In a real app: Sentry.captureException(error);
    console.error(error);
  }, [error]);

  return (
    <div className="flex flex-col items-center justify-center p-12 gap-4">
      <p className="text-sm text-muted-foreground">Something went wrong.</p>
      <Button variant="outline" size="sm" onClick={reset}>
        Try again
      </Button>
    </div>
  );
}
DASHERROR
echo "  ✅ src/app/(dashboard)/dashboard/error.tsx"

# ============================================================================
# API ROUTE
# ============================================================================

echo ""
echo "🌐 Scaffolding API route..."

cat > src/app/api/tasks/route.ts << 'APIROUTE'
// ─── API Route: /api/tasks ────────────────────────────────────────────────────
// This is a Next.js Route Handler — it runs on the SERVER, never in the browser.
// It's how you build your own backend API endpoints inside a Next.js app.
//
// File location determines the URL:
//   src/app/api/tasks/route.ts        →  GET/POST /api/tasks
//   src/app/api/tasks/[id]/route.ts   →  GET/PATCH/DELETE /api/tasks/:id
//
// ⚠️  This route has NO authentication check — intentional for this reference project.
// In a real app, the FIRST thing every route handler does is verify the user:
//
//   // NextAuth:
//   const session = await getServerSession(authOptions);
//   if (!session) return NextResponse.json({ error: 'Unauthorized' }, { status: 401 });
//
//   // Clerk:
//   const { userId } = auth();
//   if (!userId) return NextResponse.json({ error: 'Unauthorized' }, { status: 401 });
//
// Without this, anyone on the internet can read or change your data.
// Always add an auth check before touching the database.
//
// In a real app these functions would also:
//   1. Validate the request body with zod
//   2. Query a real database (Prisma, Drizzle, Supabase, etc.)
//
// Rule: keep route handlers thin. Move business logic to src/services/ (server-side).

import { NextRequest, NextResponse } from 'next/server';
import { mockTasks } from '@/mocks';

// GET /api/tasks
export async function GET() {
  try {
    // Real app: const tasks = await db.task.findMany({ where: { userId: session.user.id } });
    return NextResponse.json({ tasks: mockTasks }, { status: 200 });
  } catch {
    return NextResponse.json({ error: 'Failed to fetch tasks' }, { status: 500 });
  }
}

// POST /api/tasks
export async function POST(request: NextRequest) {
  try {
    const body = await request.json();

    // Real app: validate with zod, then insert into DB
    // const parsed = createTaskSchema.parse(body);
    // const task = await db.task.create({ data: { ...parsed, userId: session.user.id } });

    const newTask = {
      id: String(Date.now()),
      title: body.title,
      completed: false,
      createdAt: new Date().toISOString(),
    };

    return NextResponse.json({ task: newTask }, { status: 201 });
  } catch {
    return NextResponse.json({ error: 'Failed to create task' }, { status: 500 });
  }
}
APIROUTE
echo "  ✅ src/app/api/tasks/route.ts"

# ============================================================================
# MIDDLEWARE
# ============================================================================

echo ""
echo "🔒 Scaffolding middleware..."

cat > src/middleware.ts << 'MIDDLEWARE'
// ─── Middleware ───────────────────────────────────────────────────────────────
// Runs on the EDGE (between the request and the page) before every matched route.
// This is where route protection lives in real Next.js apps.
//
// How it works:
//   1. User requests /dashboard
//   2. Next.js runs this middleware FIRST
//   3. If not logged in → redirect to /login
//   4. If logged in → continue to the page
//
// This keeps auth logic in ONE place instead of checking it inside every page.
//
// ── Matcher ───────────────────────────────────────────────────────────────────
// The matcher below limits which routes trigger this middleware.
// Without it, middleware would run on EVERY request including images, fonts, etc.
// Best practice: always be explicit about what you want to protect.
//
// ── Auth providers ────────────────────────────────────────────────────────────
// In a real app, replace the TODO comment with your auth provider's check:
//
//   Clerk:
//     import { clerkMiddleware, createRouteMatcher } from '@clerk/nextjs/server';
//     const isProtected = createRouteMatcher(['/dashboard(.*)']);
//     export default clerkMiddleware(async (auth, req) => {
//       if (isProtected(req)) await auth.protect();
//     });
//
//   NextAuth:
//     export { default } from 'next-auth/middleware';
//
// ── What this reference version does ─────────────────────────────────────────
// It only logs the request — no real auth check — so the project runs without
// needing an auth provider. The structure shows you exactly where to add one.

import { NextRequest, NextResponse } from 'next/server';

export function middleware(request: NextRequest) {
  const { pathname } = request.nextUrl;

  // TODO: Replace this with your auth provider's session check
  // Example with Clerk: const { userId } = auth();
  // Example with NextAuth: const session = await getToken({ req: request });
  const isAuthenticated = true; // always true in this reference project

  // Protect all dashboard routes
  if (pathname.startsWith('/dashboard') && !isAuthenticated) {
    return NextResponse.redirect(new URL('/login', request.url));
  }

  // Redirect logged-in users away from login page
  if (pathname === '/login' && isAuthenticated) {
    return NextResponse.redirect(new URL('/dashboard', request.url));
  }

  return NextResponse.next();
}

export const config = {
  // Only run middleware on these routes — never on static files or Next.js internals
  matcher: [
    '/dashboard/:path*',
    '/login',
    // Add more protected routes here: '/settings/:path*', '/profile/:path*'
  ],
};
MIDDLEWARE
echo "  ✅ src/middleware.ts"

# ============================================================================
# SERVER ACTIONS
# ============================================================================

echo ""
echo "⚡ Scaffolding server actions..."

mkdir -p src/actions

cat > src/actions/tasks.actions.ts << 'ACTIONS'
// ─── Task Server Actions ──────────────────────────────────────────────────────
// Server Actions are functions that run ON THE SERVER but can be called
// directly from Client Components — no API route needed.
//
// ── API Route vs Server Action ────────────────────────────────────────────────
//
//   API Route (app/api/tasks/route.ts):
//     - A URL endpoint: POST /api/tasks
//     - Called via fetch() from a service/hook
//     - Works for any client: browser, mobile app, external service
//     - More boilerplate: route + service + hook
//
//   Server Action (this file):
//     - A function called directly: await createTask(input)
//     - No URL, no fetch() — Next.js handles the communication
//     - Only works from within your Next.js app
//     - Less boilerplate: one function, call it from a form or component
//
// ── When to use which ─────────────────────────────────────────────────────────
//   Server Action → form submissions, simple mutations inside your own app
//   API Route     → public API, used by mobile apps, or needs a URL
//
// ── How to call a Server Action ───────────────────────────────────────────────
//
//   From a Server Component or async function:
//     import { createTask } from '@/actions/tasks.actions';
//     await createTask({ title: 'New task' });
//
//   From a Client Component:
//     'use client';
//     import { useTransition } from 'react';
//     import { createTask } from '@/actions/tasks.actions';
//     const [isPending, startTransition] = useTransition();
//     startTransition(() => createTask({ title: 'New task' }));
//
//   From a form (the cleanest pattern — no onClick, no useState):
//     <form action={createTask}>
//       <input name="title" />
//       <button type="submit">Add</button>
//     </form>

'use server';

import { revalidatePath } from 'next/cache';
import { type CreateTaskInput } from '@/types';

export async function createTask(input: CreateTaskInput) {
  // Real app: await db.task.create({ data: { ...input, userId: session.user.id } });

  // After mutating data, tell Next.js to refresh the page's cached data.
  // Server Actions equivalent of React Query's invalidateQueries.
  revalidatePath('/dashboard');

  return { success: true };
}

export async function deleteTask(id: string) {
  // Real app: await db.task.delete({ where: { id } });
  revalidatePath('/dashboard');
  return { success: true };
}

export async function toggleTask(id: string) {
  // Real app:
  //   const task = await db.task.findUnique({ where: { id } });
  //   await db.task.update({ where: { id }, data: { completed: !task.completed } });
  revalidatePath('/dashboard');
  return { success: true };
}
ACTIONS
echo "  ✅ src/actions/tasks.actions.ts"

cat > src/actions/_README.md << 'ACTIONSREADME'
# actions/

Server Actions — functions that run on the server, called directly from components.
Introduced in Next.js 13.4, widely used in Next.js 14+.

## What goes here
- Mutations: create, update, delete
- Form handlers
- Any server-side write operation

## What does NOT go here
- Read operations → use services/ or fetch directly in Server Components
- Business logic → keep in services/, call from here

## API Route vs Server Action — quick guide

| | API Route | Server Action |
|---|---|---|
| Has a URL | ✅ `/api/tasks` | ❌ no URL |
| Called via | `fetch()` | direct function call |
| Works from | anywhere | your Next.js app only |
| Best for | public API, mobile apps | forms, internal mutations |
| Boilerplate | more | less |

## Key rule
Always call `revalidatePath()` or `revalidateTag()` after mutating data —
this tells Next.js to refresh the cached page so users see the update.

## Naming
`<feature>.actions.ts`
ACTIONSREADME
echo "  ✅ src/actions/_README.md"

echo ""
echo "🧱 Scaffolding layout components..."

cat > src/components/layout/_README.md << 'LAYOUTREADME'
# components/layout/

Shell-level UI components that wrap the entire app or a major section of it.

## What goes here
- `Navbar.tsx`      — top navigation bar
- `Sidebar.tsx`     — side navigation panel
- `Footer.tsx`      — site footer (if needed)
- `MobileMenu.tsx`  — mobile nav drawer

## What does NOT go here
- Feature-specific UI → `components/features/<feature>/`
- Reusable UI pieces (buttons, dialogs) → `components/shared/`

## Naming convention
PascalCase. One component per file. Name it exactly what it is.

## Notes
These components are imported by route layouts (e.g. `app/(dashboard)/layout.tsx`),
not by pages or feature components. Keep them focused on structure, not business logic.
LAYOUTREADME

cat > src/components/layout/Navbar.tsx << 'NAVBAR'
// ─── Navbar ───────────────────────────────────────────────────────────────────
// Top navigation bar — rendered by the dashboard layout.
// Kept as a Client Component so ThemeToggle (which uses a hook) works inside it.
//
// In a real app this would also show:
//   - The current user's avatar / name (from AuthContext or a server component)
//   - Notifications
//   - A mobile menu toggle

'use client';

import Link from 'next/link';
import { siteConfig } from '@/config/site';
import ThemeToggle from '@/components/shared/ThemeToggle';

const Navbar = () => {
  return (
    <header className="h-14 border-b bg-background flex items-center px-4 gap-4 shrink-0">
      {/* App name / logo */}
      <Link href="/dashboard" className="font-semibold text-sm">
        {siteConfig.name}
      </Link>

      {/* Push everything after this to the right */}
      <div className="ml-auto flex items-center gap-2">
        <ThemeToggle />
        {/* Real app: <UserMenu /> */}
      </div>
    </header>
  );
};

export default Navbar;
NAVBAR
echo "  ✅ src/components/layout/Navbar.tsx"

cat > src/components/layout/Sidebar.tsx << 'SIDEBAR'
// ─── Sidebar ──────────────────────────────────────────────────────────────────
// Left sidebar navigation — rendered by the dashboard layout.
//
// In a real app this would:
//   - Highlight the active route using usePathname()
//   - Conditionally show items based on user role/permissions
//   - Collapse on mobile

'use client';

import Link from 'next/link';
import { usePathname } from 'next/navigation';
import { cn } from '@/lib/utils';
import { siteConfig } from '@/config/site';

const Sidebar = () => {
  const pathname = usePathname();

  return (
    <aside className="w-56 border-r bg-background shrink-0 hidden md:flex flex-col py-4 px-2">
      <nav className="flex flex-col gap-1">
        {siteConfig.nav.map(item => (
          <Link
            key={item.href}
            href={item.href}
            className={cn(
              'text-sm px-3 py-2 rounded-md transition-colors hover:bg-muted',
              // Active state — highlight the current route
              pathname === item.href
                ? 'bg-muted font-medium text-foreground'
                : 'text-muted-foreground'
            )}
          >
            {item.label}
          </Link>
        ))}
      </nav>
    </aside>
  );
};

export default Sidebar;
SIDEBAR
echo "  ✅ src/components/layout/Sidebar.tsx"

# ============================================================================
# SHARED COMPONENTS
# ============================================================================

echo ""
echo "🧩 Scaffolding shared components..."

cat > src/components/shared/_README.md << 'SHAREDREADME'
# components/shared/

Reusable UI components used across the whole app.
These are NOT tied to any feature — they could be dropped into any project.

## What goes here
- Generic feedback UI (LoadingSpinner, EmptyState)
- Generic interaction UI (ConfirmDialog, ThemeToggle)
- Generic display UI (PageHeader)

## What does NOT go here
- Anything that imports from `src/services/` or `src/hooks/` → `components/features/`
- Shell/nav components → `components/layout/`
- Page-level layout and composition → `components/features/<name>/<Name>View.tsx`
- shadcn/ui primitives → `components/ui/` (auto-generated by shadcn, don't touch)

## Why no layout wrapper (like Dashboard.tsx) here?
The shell layout is `layout.tsx`'s job.
The page content layout is the `*View.tsx` component's job (e.g. DashboardView.tsx).
A generic layout wrapper in shared/ would sit between those two with no clear owner.

## Naming convention
PascalCase. Descriptive. Qualifier at the end:
  LoadingSpinner ✅   SpinnerLoading ❌
  ConfirmDialog  ✅   DialogConfirm  ❌
SHAREDREADME

cat > src/components/shared/PageHeader.tsx << 'PAGEHEADER'
// ─── PageHeader ───────────────────────────────────────────────────────────────
// Consistent page title + optional subtitle.
// Used at the top of every major page inside a Dashboard wrapper.
//
// Usage:
//   <PageHeader title="Tasks" subtitle="Manage your to-dos." />

interface PageHeaderProps {
  title: string;
  subtitle?: string;
}

const PageHeader = ({ title, subtitle }: PageHeaderProps) => {
  return (
    <div className="mb-2">
      <h1 className="text-2xl font-semibold tracking-tight">{title}</h1>
      {subtitle && (
        <p className="text-sm text-muted-foreground mt-1">{subtitle}</p>
      )}
    </div>
  );
};

export default PageHeader;
PAGEHEADER
echo "  ✅ src/components/shared/PageHeader.tsx"

cat > src/components/shared/LoadingSpinner.tsx << 'SPINNER'
// ─── LoadingSpinner ───────────────────────────────────────────────────────────
// Simple animated spinner for loading states.
//
// Usage:
//   <LoadingSpinner />

const LoadingSpinner = () => {
  return (
    <div className="flex items-center justify-center p-4">
      <div className="h-5 w-5 animate-spin rounded-full border-2 border-muted border-t-foreground" />
    </div>
  );
};

export default LoadingSpinner;
SPINNER
echo "  ✅ src/components/shared/LoadingSpinner.tsx"

cat > src/components/shared/EmptyState.tsx << 'EMPTYSTATE'
// ─── EmptyState ───────────────────────────────────────────────────────────────
// Shown when a list has no items to display.
//
// Usage:
//   {tasks.length === 0 && <EmptyState message="No tasks yet." />}

interface EmptyStateProps {
  message?: string;
}

const EmptyState = ({ message = 'Nothing here yet.' }: EmptyStateProps) => {
  return (
    <div className="flex items-center justify-center py-12">
      <p className="text-sm text-muted-foreground">{message}</p>
    </div>
  );
};

export default EmptyState;
EMPTYSTATE
echo "  ✅ src/components/shared/EmptyState.tsx"

cat > src/components/shared/ConfirmDialog.tsx << 'CONFIRMDIALOG'
// ─── ConfirmDialog ────────────────────────────────────────────────────────────
// Reusable confirmation dialog for destructive actions (delete, reset, etc.)
// Wraps shadcn's Dialog so you don't repeat this pattern everywhere.
//
// Usage:
//   const [open, setOpen] = useState(false);
//
//   <Button onClick={() => setOpen(true)}>Delete</Button>
//   <ConfirmDialog
//     open={open}
//     onOpenChange={setOpen}
//     title="Delete task?"
//     description="This cannot be undone."
//     onConfirm={handleDelete}
//   />

'use client';

import {
  Dialog,
  DialogContent,
  DialogDescription,
  DialogFooter,
  DialogHeader,
  DialogTitle,
} from '@/components/ui/dialog';
import { Button } from '@/components/ui/button';

interface ConfirmDialogProps {
  open: boolean;
  onOpenChange: (open: boolean) => void;
  title?: string;
  description?: string;
  confirmLabel?: string;
  cancelLabel?: string;
  onConfirm: () => void;
}

const ConfirmDialog = ({
  open,
  onOpenChange,
  title = 'Are you sure?',
  description = 'This action cannot be undone.',
  confirmLabel = 'Confirm',
  cancelLabel = 'Cancel',
  onConfirm,
}: ConfirmDialogProps) => {
  return (
    <Dialog open={open} onOpenChange={onOpenChange}>
      <DialogContent>
        <DialogHeader>
          <DialogTitle>{title}</DialogTitle>
          <DialogDescription>{description}</DialogDescription>
        </DialogHeader>
        <DialogFooter>
          <Button variant="outline" onClick={() => onOpenChange(false)}>
            {cancelLabel}
          </Button>
          <Button
            variant="destructive"
            onClick={() => {
              onConfirm();
              onOpenChange(false);
            }}
          >
            {confirmLabel}
          </Button>
        </DialogFooter>
      </DialogContent>
    </Dialog>
  );
};

export default ConfirmDialog;
CONFIRMDIALOG
echo "  ✅ src/components/shared/ConfirmDialog.tsx"

cat > src/components/shared/ThemeToggle.tsx << 'THEMETOGGLE'
// ─── ThemeToggle ──────────────────────────────────────────────────────────────
// Button that switches between light and dark mode.
// Uses next-themes — ThemeProvider must wrap the app (see layout.tsx).
//
// How dark mode works end to end:
//   1. ThemeProvider (context/ThemeProvider.tsx) sets up next-themes
//   2. next-themes adds/removes the 'dark' class on <html>
//   3. Tailwind sees that class and activates dark: variants
//   4. shadcn/ui CSS variables switch automatically
//
// Usage:
//   <ThemeToggle />

'use client';

import { useTheme } from 'next-themes';
import { Button } from '@/components/ui/button';
import { Moon, Sun } from 'lucide-react';

const ThemeToggle = () => {
  const { theme, setTheme } = useTheme();

  return (
    <Button
      variant="ghost"
      size="icon"
      onClick={() => setTheme(theme === 'dark' ? 'light' : 'dark')}
      aria-label="Toggle theme"
    >
      <Sun className="h-4 w-4 rotate-0 scale-100 transition-all dark:-rotate-90 dark:scale-0" />
      <Moon className="absolute h-4 w-4 rotate-90 scale-0 transition-all dark:rotate-0 dark:scale-100" />
    </Button>
  );
};

export default ThemeToggle;
THEMETOGGLE
echo "  ✅ src/components/shared/ThemeToggle.tsx"

# ============================================================================
# FEATURE: TASKS
# ============================================================================

echo ""
echo "✅ Scaffolding tasks feature..."

cat > src/components/features/tasks/_README.md << 'TASKSREADME'
# components/features/tasks/

All UI components related to the tasks feature.

## What goes here
Every component SPECIFIC to tasks:
  - `TaskCard.tsx`  — displays a single task
  - `TaskList.tsx`  — renders a list of TaskCards
  - `TaskForm.tsx`  — form for creating/editing a task

## What does NOT go here
- Generic UI → `components/shared/`
- Data fetching → `hooks/useTasks.ts`
- API calls → `services/tasks.service.ts`
- Types → `types/task.types.ts`

## The full pattern for any feature
  types → mocks → service → hook → components → route → API route → nav

  Each layer only talks to the layer below it:
  components → hooks → services → lib/api → API routes → database

## Naming convention
  [FeatureName][Role].tsx
  TaskCard.tsx  ✅   CardTask.tsx ❌
  TaskList.tsx  ✅   Tasks.tsx    ❌  (too vague)
  TaskForm.tsx  ✅   Form.tsx     ❌  (too generic)
TASKSREADME

cat > src/components/features/tasks/TaskCard.tsx << 'TASKCARD'
// ─── TaskCard ─────────────────────────────────────────────────────────────────
// Displays a single task.
// This is a "dumb" / presentational component:
//   - Receives data via props
//   - Fires events via callbacks
//   - Does NOT fetch data, call services, or manage its own state
//
// The parent (TaskList) manages state and passes handlers down.
// This makes TaskCard easy to reuse, test, and understand.

import { type Task } from '@/types';
import { Badge } from '@/components/ui/badge';
import { cn } from '@/lib/utils';

interface TaskCardProps {
  task: Task;
  onToggle: (id: string) => void;
  onDelete: (id: string) => void;
}

const TaskCard = ({ task, onToggle, onDelete }: TaskCardProps) => {
  return (
    <div className="flex items-center justify-between p-3 border rounded-lg bg-card">
      <div className="flex items-center gap-3">
        <input
          type="checkbox"
          checked={task.completed}
          onChange={() => onToggle(task.id)}
          className="h-4 w-4 cursor-pointer"
        />
        <span className={cn('text-sm', task.completed && 'line-through text-muted-foreground')}>
          {task.title}
        </span>
      </div>
      <div className="flex items-center gap-2">
        <Badge variant={task.completed ? 'secondary' : 'default'}>
          {task.completed ? 'Done' : 'Pending'}
        </Badge>
        <button
          onClick={() => onDelete(task.id)}
          className="text-xs text-muted-foreground hover:text-destructive transition-colors"
        >
          Delete
        </button>
      </div>
    </div>
  );
};

export default TaskCard;
TASKCARD
echo "  ✅ src/components/features/tasks/TaskCard.tsx"

cat > src/components/features/tasks/TaskList.tsx << 'TASKLIST'
// ─── TaskList ─────────────────────────────────────────────────────────────────
// Renders a list of tasks. Manages list-level state (toggle, delete).
// Client Component because it uses useState.
//
// ⚠️  Real world note:
// The toggle/delete handlers here update LOCAL React state only.
// This works fine with mock data but breaks with a real database — if you
// refresh the page, your changes are gone because nothing was saved to the server.
//
// In a real app you'd use one of these patterns instead:
//
// 1. Server Actions (modern Next.js approach):
//    async function deleteTask(id: string) {
//      'use server';
//      await db.task.delete({ where: { id } });
//      revalidatePath('/dashboard');  // tells Next.js to refetch the page
//    }
//
// 2. React Query mutations:
//    const { mutate: deleteTask } = useMutation({
//      mutationFn: tasksService.delete,
//      onSuccess: () => queryClient.invalidateQueries({ queryKey: ['tasks'] }),
//    });
//
// Both approaches keep the server as the source of truth.
// The local useState pattern shown here is only safe for UI-only state
// (e.g. "is this dropdown open") not for data that needs to persist.
//
// Pattern:
//   TaskList  — manages the list, owns the handlers
//   TaskCard  — renders one item, fires callbacks up to TaskList

'use client';

import { useState } from 'react';
import { type Task } from '@/types';
import TaskCard from './TaskCard';
import EmptyState from '@/components/shared/EmptyState';

interface TaskListProps {
  tasks: Task[];
}

const TaskList = ({ tasks: initialTasks }: TaskListProps) => {
  const [tasks, setTasks] = useState<Task[]>(initialTasks);

  const handleToggle = (id: string) => {
    setTasks(prev =>
      prev.map(task => (task.id === id ? { ...task, completed: !task.completed } : task))
    );
    // Real app: await tasksService.toggle(id);
  };

  const handleDelete = (id: string) => {
    setTasks(prev => prev.filter(task => task.id !== id));
    // Real app: await tasksService.delete(id);
  };

  if (tasks.length === 0) {
    return <EmptyState message="No tasks yet. Add one above." />;
  }

  return (
    <div className="flex flex-col gap-2">
      {tasks.map(task => (
        <TaskCard
          key={task.id}
          task={task}
          onToggle={handleToggle}
          onDelete={handleDelete}
        />
      ))}
    </div>
  );
};

export default TaskList;
TASKLIST
echo "  ✅ src/components/features/tasks/TaskList.tsx"

cat > src/components/features/tasks/TaskForm.tsx << 'TASKFORM'
// ─── TaskForm ─────────────────────────────────────────────────────────────────
// Form for creating a new task.
// Uses controlled input (React state). In a real app with validation,
// you'd use react-hook-form + zod here instead.
//
// Pattern for forms:
//   1. Local state for the input value
//   2. onSubmit calls a prop callback (parent decides what to do with data)
//   3. Form resets after submission
//   4. Basic validation before submitting (don't submit empty)

'use client';

import { useState } from 'react';
import { Input } from '@/components/ui/input';
import { Button } from '@/components/ui/button';

interface TaskFormProps {
  onAdd: (title: string) => void;
}

const TaskForm = ({ onAdd }: TaskFormProps) => {
  const [value, setValue] = useState('');

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    const trimmed = value.trim();
    if (!trimmed) return;
    onAdd(trimmed);
    setValue('');
  };

  return (
    <form onSubmit={handleSubmit} className="flex gap-2">
      <Input
        value={value}
        onChange={e => setValue(e.target.value)}
        placeholder="Add a new task..."
        className="flex-1"
      />
      <Button type="submit" disabled={!value.trim()}>
        Add
      </Button>
    </form>
  );
};

export default TaskForm;
TASKFORM
echo "  ✅ src/components/features/tasks/TaskForm.tsx"

# Dashboard feature
mkdir -p src/components/features/dashboard

cat > src/components/features/dashboard/DashboardView.tsx << 'DASHVIEW'
// ─── DashboardView ────────────────────────────────────────────────────────────
// The actual content of the dashboard page.
// This is where layout classes and feature components are composed together.
//
// Why this exists instead of putting content directly in page.tsx:
//   - page.tsx should be routing only — as lean as possible
//   - This component owns the "what does this page look like" concern
//   - Named *View to signal: this is what a page renders, not a reusable piece
//   - Easy to test in isolation without the Next.js routing layer
//
// Convention:
//   page.tsx       → routing only, imports the View
//   *View.tsx      → layout + composition of feature components
//   feature/*.tsx  → individual feature components (TaskList, TaskCard, etc.)

import PageHeader from '@/components/shared/PageHeader';
import TaskList from '@/components/features/tasks/TaskList';
import { mockTasks } from '@/mocks';

const DashboardView = () => {
  // In a real app you'd fetch data here or receive it as props from page.tsx:
  // const tasks = await tasksService.getAll();  (if called from a Server Component page)
  const tasks = mockTasks;

  return (
    <div className="max-w-2xl mx-auto p-6 space-y-6">
      <PageHeader
        title="Dashboard"
        subtitle="Here's what's on your plate."
      />
      <TaskList tasks={tasks} />
    </div>
  );
};

export default DashboardView;
DASHVIEW
echo "  ✅ src/components/features/dashboard/DashboardView.tsx"

# ============================================================================
# TYPES
# ============================================================================

echo ""
echo "📐 Scaffolding types..."

cat > src/types/_README.md << 'TYPESREADME'
# types/

Shared TypeScript types used in more than one place.

## What goes here
- `task.ts`  — Task, CreateTaskInput, UpdateTaskInput
- `auth.ts`  — User, Session, LoginInput
- `api.ts`   — ApiResponse<T>, PaginatedResponse<T>

## Naming convention
`<feature>.ts` — NOT `<feature>.types.ts`
The `types/` folder already tells you these are types. The `.types.ts` suffix
is redundant and you'll rarely see it in professional codebases.

  task.ts  ✅   task.types.ts  ❌

## What does NOT go here
- Types used in only one file → define them locally in that file
- Types auto-generated by Prisma/Supabase → import from their packages directly

## index.ts
Re-exports everything for clean imports:
  import { type Task } from '@/types';  ✅
TYPESREADME

cat > src/types/task.ts << 'TASKTYPES'
// ─── Task Types ───────────────────────────────────────────────────────────────
// Define the base type first, then derive input types from it.
// If Task changes, input types stay in sync automatically.

export interface Task {
  id: string;
  title: string;
  completed: boolean;
  createdAt: string; // ISO string — use string not Date for JSON compatibility
}

// What you send to CREATE a task (id and createdAt set by the server)
export type CreateTaskInput = Pick<Task, 'title'>;

// What you send to UPDATE a task (all fields optional)
export type UpdateTaskInput = Partial<Pick<Task, 'title' | 'completed'>>;
TASKTYPES
echo "  ✅ src/types/task.ts"

cat > src/types/auth.ts << 'AUTHTYPES'
// ─── Auth Types ───────────────────────────────────────────────────────────────

export interface User {
  id: string;
  name: string;
  email: string;
  avatarUrl?: string;
}

export interface Session {
  user: User;
  expiresAt: string;
}

export type LoginInput = {
  email: string;
  password: string;
};
AUTHTYPES
echo "  ✅ src/types/auth.ts"

cat > src/types/api.ts << 'APITYPES'
// ─── API Types ────────────────────────────────────────────────────────────────
// Generic wrappers for API responses. Use in services for consistent shapes.
//
// Usage in a service:
//   const data = await api.get<ApiResponse<Task[]>>('/api/tasks');
//   data.data  →  Task[]

export interface ApiResponse<T> {
  data: T;
  message?: string;
}

export interface PaginatedResponse<T> {
  data: T[];
  total: number;
  page: number;
  pageSize: number;
}

export interface ApiError {
  error: string;
  status: number;
}
APITYPES
echo "  ✅ src/types/api.ts"

cat > src/types/index.ts << 'TYPESBARREL'
// ─── Types Barrel ─────────────────────────────────────────────────────────────
// Re-exports everything for clean imports:
//   import { type Task, type User } from '@/types';
//
// Naming: task.ts not task.types.ts — the types/ folder already tells you what's here.
// You'll see this convention in most modern Next.js and TypeScript codebases.

export type { Task, CreateTaskInput, UpdateTaskInput } from './task';
export type { User, Session, LoginInput } from './auth';
export type { ApiResponse, PaginatedResponse, ApiError } from './api';
TYPESBARREL
echo "  ✅ src/types/index.ts"

# ============================================================================
# MOCKS
# ============================================================================

echo ""
echo "🎭 Scaffolding mocks..."

cat > src/mocks/_README.md << 'MOCKSREADME'
# mocks/

Hardcoded sample data used during development before a real backend exists.

## Honest note — do real projects have a mocks/ folder?
Not usually like this. In professional codebases mocks are handled differently:

- **MSW (Mock Service Worker)** — the industry standard. Intercepts real network
  requests and returns fake responses. Lives in `src/msw/` or `__mocks__/`.
  Used during development AND in tests.
- **DB seed scripts** — `prisma/seed.ts` populates a real local database with
  sample data. More common in full-stack apps.
- **Inline hardcoding** — many solo devs just hardcode data directly in the page
  while building, then replace it with real fetches later. No dedicated folder.

This `mocks/` folder exists here purely as a learning scaffold — it keeps the
reference project runnable and shows you what the data shapes look like in practice.

## Key rule
Mock data must always match your TypeScript types exactly.
If a type changes, update the mocks — otherwise you're practising the wrong shape.

## When to replace
When your backend is ready, replace mock imports in services with real API calls.
MOCKSREADME

cat > src/mocks/tasks.mock.ts << 'TASKSMOCK'
// ─── Task Mocks ───────────────────────────────────────────────────────────────
// Sample tasks for development. Must match the Task type exactly.

import { type Task } from '@/types';

export const mockTasks: Task[] = [
  {
    id: '1',
    title: 'Read the _README.md in each folder',
    completed: false,
    createdAt: '2025-01-01T09:00:00.000Z',
  },
  {
    id: '2',
    title: 'Understand the types → mocks → service → hook → component pattern',
    completed: false,
    createdAt: '2025-01-01T09:05:00.000Z',
  },
  {
    id: '3',
    title: 'Study how ThemeToggle and ThemeProvider wire together',
    completed: true,
    createdAt: '2025-01-01T09:10:00.000Z',
  },
];
TASKSMOCK
echo "  ✅ src/mocks/tasks.mock.ts"

cat > src/mocks/index.ts << 'MOCKSBARREL'
export { mockTasks } from './tasks.mock';
MOCKSBARREL
echo "  ✅ src/mocks/index.ts"

# ============================================================================
# SERVICES
# ============================================================================

echo ""
echo "⚙️  Scaffolding services..."

cat > src/services/_README.md << 'SERVICESREADME'
# services/

Functions that talk to your API. One file per feature/resource.

## What goes here
- `tasks.service.ts`  — getAll, getById, create, toggle, delete
- `auth.service.ts`   — login, logout, getMe

## What does NOT go here
- The fetch client → `lib/api/client.ts`
- URL strings → `lib/api/endpoints.ts`
- UI state or React → that's for hooks/

## Honest note — do all projects have a services/ folder?
It depends on the stack:

- **REST API projects** — yes, services/ is common and clean. This is what this project shows.
- **Small solo projects** — many developers skip this layer and call fetch directly
  inside hooks. Totally valid for small projects.
- **React Query projects** — query functions often live inline in the hook or in a
  `queries/` folder. The services/ pattern is less common here.
- **tRPC projects** — there's no manual fetch at all. tRPC generates fully typed
  API calls automatically. No services/ folder needed.

Understanding services/ is worth your time even if you end up using React Query or tRPC
later — the concept of separating "how you get data" from "how you display it" stays the same.

## The rule
Services are the ONLY place that imports from `lib/api`.
Hooks call services. Components call hooks. Nothing skips a layer.

## Naming convention
  `<feature>.service.ts`

## Return types
Always type your returns:
  async getAll(): Promise<Task[]>
  async create(input: CreateTaskInput): Promise<Task>
SERVICESREADME

cat > src/services/tasks.service.ts << 'TASKSSERVICE'
// ─── Tasks Service ────────────────────────────────────────────────────────────
// All API calls for tasks. Import this in hooks, NOT directly in components.
//
// These functions currently return mock data.
// To connect to a real backend, swap the mock returns for api.get/post/patch/delete calls.

import { type Task, type CreateTaskInput } from '@/types';
import { mockTasks } from '@/mocks';
// Real app: import { api, endpoints } from '@/lib/api';

export const tasksService = {
  getAll: async (): Promise<Task[]> => {
    // Real: return api.get<Task[]>(endpoints.tasks.list);
    return Promise.resolve(mockTasks);
  },

  getById: async (id: string): Promise<Task | undefined> => {
    // Real: return api.get<Task>(endpoints.tasks.byId(id));
    return Promise.resolve(mockTasks.find(t => t.id === id));
  },

  create: async (input: CreateTaskInput): Promise<Task> => {
    // Real: return api.post<Task>(endpoints.tasks.list, input);
    return Promise.resolve({
      id: String(Date.now()),
      title: input.title,
      completed: false,
      createdAt: new Date().toISOString(),
    });
  },

  toggle: async (id: string): Promise<Task> => {
    // Real: return api.patch<Task>(endpoints.tasks.byId(id), { completed: !current.completed });
    const task = mockTasks.find(t => t.id === id)!;
    return Promise.resolve({ ...task, completed: !task.completed });
  },

  delete: async (_id: string): Promise<void> => {
    // Real: return api.delete(endpoints.tasks.byId(id));
    return Promise.resolve();
  },
};
TASKSSERVICE
echo "  ✅ src/services/tasks.service.ts"

cat > src/services/auth.service.ts << 'AUTHSERVICE'
// ─── Auth Service ─────────────────────────────────────────────────────────────

import { type LoginInput, type Session } from '@/types';
import { api, endpoints } from '@/lib/api';

export const authService = {
  login:  (input: LoginInput): Promise<Session> => api.post<Session>(endpoints.auth.login, input),
  logout: (): Promise<void>                      => api.post<void>(endpoints.auth.logout, {}),
  getMe:  (): Promise<Session>                   => api.get<Session>(endpoints.auth.me),
};
AUTHSERVICE
echo "  ✅ src/services/auth.service.ts"

cat > src/services/index.ts << 'SERVICESBARREL'
export { tasksService } from './tasks.service';
export { authService } from './auth.service';
SERVICESBARREL
echo "  ✅ src/services/index.ts"

# ============================================================================
# HOOKS
# ============================================================================

echo ""
echo "🪝 Scaffolding hooks..."

cat > src/hooks/_README.md << 'HOOKSREADME'
# hooks/

Custom React hooks. Each does one thing well.

## What goes here
- Data hooks: `useTasks.ts`, `useUser.ts` — manage loading/error/data for a feature
- Utility hooks: `useDebounce.ts`, `useLocalStorage.ts` — reusable behaviour

## What does NOT go here
- Hooks only used in one component → keep them in that component file
- API calls directly → call a service from inside the hook

## Honest note — React Query
The data hooks here (useTasks) manually manage loading/error/data state with
useState + useEffect. This is a good pattern to learn because it teaches you
exactly what's happening under the hood.

In real professional projects however, most teams use **React Query** (also called
TanStack Query) instead of writing this manually. React Query gives you:
  - loading, error, data state automatically
  - caching (so the same data isn't fetched twice)
  - background refetching
  - mutation handling (create, update, delete)

With React Query, useTasks would look like this instead:
  import { useQuery, useMutation } from '@tanstack/react-query';
  const { data: tasks, isLoading, error } = useQuery({
    queryKey: ['tasks'],
    queryFn: tasksService.getAll,
  });

Understanding the manual pattern first (what's in this file) makes React Query
much easier to learn. Think of this as the foundation.

## The data hook pattern (manual version)
  1. Holds loading, error, and data state
  2. Calls a service function (never imports lib/api directly)
  3. Returns state + action handlers
  4. Component destructures what it needs

## Naming
Always starts with 'use': useTasks, useDebounce, useLocalStorage
HOOKSREADME

cat > src/hooks/useTasks.ts << 'USETASKS'
// ─── useTasks ─────────────────────────────────────────────────────────────────
// Data hook for the tasks feature.
// Bridge between components and tasksService.
//
// Flow:
//   component → useTasks() → tasksService → api client → /api/tasks
//
// Components never call services directly.
// Services never know about React or components.
//
// ⚠️  Real world note:
// This hook manually manages loading/error/data with useState + useEffect.
// This is great for learning what's happening under the hood.
// In professional projects most teams replace this with React Query:
//
//   const { data: tasks, isLoading, error } = useQuery({
//     queryKey: ['tasks'],
//     queryFn: tasksService.getAll,
//   });
//
//   const { mutate: addTask } = useMutation({
//     mutationFn: tasksService.create,
//     onSuccess: () => queryClient.invalidateQueries({ queryKey: ['tasks'] }),
//   });
//
// React Query handles caching, refetching, and loading states automatically.
// Learn the manual pattern here first — it makes React Query much easier to understand.

'use client';

import { useState, useEffect } from 'react';
import { type Task, type CreateTaskInput } from '@/types';
import { tasksService } from '@/services';

interface UseTasksReturn {
  tasks: Task[];
  loading: boolean;
  error: string | null;
  addTask: (input: CreateTaskInput) => Promise<void>;
  toggleTask: (id: string) => Promise<void>;
  deleteTask: (id: string) => Promise<void>;
}

export function useTasks(): UseTasksReturn {
  const [tasks, setTasks] = useState<Task[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    const load = async () => {
      try {
        const data = await tasksService.getAll();
        setTasks(data);
      } catch {
        setError('Failed to load tasks.');
      } finally {
        setLoading(false);
      }
    };
    load();
  }, []);

  const addTask = async (input: CreateTaskInput) => {
    const newTask = await tasksService.create(input);
    // Optimistic update — update local state immediately without refetching
    setTasks(prev => [newTask, ...prev]);
  };

  const toggleTask = async (id: string) => {
    const updated = await tasksService.toggle(id);
    setTasks(prev => prev.map(t => (t.id === id ? updated : t)));
  };

  const deleteTask = async (id: string) => {
    await tasksService.delete(id);
    setTasks(prev => prev.filter(t => t.id !== id));
  };

  return { tasks, loading, error, addTask, toggleTask, deleteTask };
}
USETASKS
echo "  ✅ src/hooks/useTasks.ts"

cat > src/hooks/useDebounce.ts << 'DEBOUNCE'
// ─── useDebounce ──────────────────────────────────────────────────────────────
// Delays a value until the user stops changing it for `delay` ms.
// Classic use: search inputs — don't fire an API call on every keystroke.
//
// Usage:
//   const debouncedSearch = useDebounce(searchInput, 300);
//   useEffect(() => { fetchResults(debouncedSearch); }, [debouncedSearch]);

import { useState, useEffect } from 'react';

export function useDebounce<T>(value: T, delay = 300): T {
  const [debouncedValue, setDebouncedValue] = useState<T>(value);

  useEffect(() => {
    const timer = setTimeout(() => setDebouncedValue(value), delay);
    return () => clearTimeout(timer); // cancel if value changes before delay
  }, [value, delay]);

  return debouncedValue;
}
DEBOUNCE
echo "  ✅ src/hooks/useDebounce.ts"

cat > src/hooks/useLocalStorage.ts << 'LOCALSTORAGE'
// ─── useLocalStorage ──────────────────────────────────────────────────────────
// Persistent state backed by localStorage. Works like useState but survives refreshes.
//
// Usage:
//   const [sidebarOpen, setSidebarOpen] = useLocalStorage('sidebar-open', true);
//
// Notes:
//   - typeof window check prevents SSR errors (Next.js renders server-side first)
//   - Values must be JSON-serialisable (string, number, object — not Date, Map, Set)

import { useState, useEffect } from 'react';

export function useLocalStorage<T>(key: string, initialValue: T) {
  const [storedValue, setStoredValue] = useState<T>(() => {
    if (typeof window === 'undefined') return initialValue;
    try {
      const item = window.localStorage.getItem(key);
      return item ? (JSON.parse(item) as T) : initialValue;
    } catch {
      return initialValue;
    }
  });

  useEffect(() => {
    if (typeof window === 'undefined') return;
    try {
      window.localStorage.setItem(key, JSON.stringify(storedValue));
    } catch {
      console.warn(`useLocalStorage: could not save key "${key}"`);
    }
  }, [key, storedValue]);

  return [storedValue, setStoredValue] as const;
}
LOCALSTORAGE
echo "  ✅ src/hooks/useLocalStorage.ts"

# ============================================================================
# LIB
# ============================================================================

echo ""
echo "📚 Scaffolding lib..."

cat > src/lib/_README.md << 'LIBREADME'
# lib/

Infrastructure-level utilities. Not tied to any feature.

## What goes here
- `utils.ts`    — the cn() helper for merging Tailwind classes
- `api/`        — base fetch client and endpoint map

## What does NOT go here
- Feature logic → `services/`
- React hooks → `hooks/`
- Data formatting (formatDate) → `utils/`

## Key rule
Only `services/` should import from `lib/api/`.
LIBREADME

cat > src/lib/utils.ts << 'UTILS'
// ─── cn ───────────────────────────────────────────────────────────────────────
// Merges Tailwind CSS classes safely.
// clsx handles conditionals. twMerge resolves conflicts (e.g. px-4 vs px-6 → px-6 wins).
//
// Usage:
//   className={cn('px-4 py-2', isActive && 'bg-blue-500', className)}

import { clsx, type ClassValue } from 'clsx';
import { twMerge } from 'tailwind-merge';

export function cn(...inputs: ClassValue[]) {
  return twMerge(clsx(inputs));
}
UTILS
echo "  ✅ src/lib/utils.ts"

cat > src/lib/api/client.ts << 'CLIENT'
// ─── API Client ───────────────────────────────────────────────────────────────
// Base fetch wrapper. All HTTP calls go through here.
// Only services/ should import this — nothing else.
//
// Benefits of a central client:
//   - Add auth headers in one place
//   - Handle errors consistently
//   - Swap base URL for staging vs production in one place

const BASE_URL = process.env.NEXT_PUBLIC_API_URL ?? process.env.NEXT_PUBLIC_APP_URL ?? '';

type RequestOptions = RequestInit & {
  params?: Record<string, string>;
};

async function request<T>(endpoint: string, options: RequestOptions = {}): Promise<T> {
  const { params, ...init } = options;

  const url = new URL(`${BASE_URL}${endpoint}`);
  if (params) {
    Object.entries(params).forEach(([key, value]) => url.searchParams.set(key, value));
  }

  const res = await fetch(url.toString(), {
    headers: {
      'Content-Type': 'application/json',
      // Real app: 'Authorization': `Bearer ${getToken()}`,
      ...init.headers,
    },
    ...init,
  });

  if (!res.ok) {
    throw new Error(`API error: ${res.status} ${res.statusText}`);
  }

  return res.json() as Promise<T>;
}

export const api = {
  get:    <T>(endpoint: string, options?: RequestOptions) =>
    request<T>(endpoint, { ...options, method: 'GET' }),
  post:   <T>(endpoint: string, body: unknown, options?: RequestOptions) =>
    request<T>(endpoint, { ...options, method: 'POST', body: JSON.stringify(body) }),
  put:    <T>(endpoint: string, body: unknown, options?: RequestOptions) =>
    request<T>(endpoint, { ...options, method: 'PUT', body: JSON.stringify(body) }),
  patch:  <T>(endpoint: string, body: unknown, options?: RequestOptions) =>
    request<T>(endpoint, { ...options, method: 'PATCH', body: JSON.stringify(body) }),
  delete: <T>(endpoint: string, options?: RequestOptions) =>
    request<T>(endpoint, { ...options, method: 'DELETE' }),
};
CLIENT
echo "  ✅ src/lib/api/client.ts"

cat > src/lib/api/endpoints.ts << 'ENDPOINTS'
// ─── API Endpoints ────────────────────────────────────────────────────────────
// All URL strings in one place. Never hardcode URLs in services.
//
// If /api/tasks changes to /api/v2/tasks, you change it here once.
//
// Dynamic URLs use functions:
//   byId: (id: string) => `/api/tasks/${id}`
// Usage: api.get(endpoints.tasks.byId('123'))

export const endpoints = {
  auth: {
    login:  '/api/auth/login',
    logout: '/api/auth/logout',
    me:     '/api/auth/me',
  },
  tasks: {
    list:           '/api/tasks',
    byId: (id: string) => `/api/tasks/${id}`,
  },
};
ENDPOINTS
echo "  ✅ src/lib/api/endpoints.ts"

cat > src/lib/api/index.ts << 'APIBARREL'
export { api } from './client';
export { endpoints } from './endpoints';
APIBARREL
echo "  ✅ src/lib/api/index.ts"

# ============================================================================
# CONTEXT
# ============================================================================

echo ""
echo "🌍 Scaffolding context..."

cat > src/context/_README.md << 'CONTEXTREADME'
# context/

React Context providers for global state that many components need.

## What goes here
- `ThemeProvider.tsx`  — wraps next-themes for dark/light mode
- `AuthContext.tsx`    — current user, login/logout state

## What does NOT go here
- Feature-specific state → use a hook (useTasks)
- Server-side data → fetch in a Server Component, pass as props

## Honest note — auth context in real projects
Almost no professional project builds auth context from scratch like AuthContext.tsx here.
Instead you'd use an auth provider that handles everything for you:

- **Clerk** — `useUser()`, `useAuth()`, middleware for route protection, UI components
- **NextAuth / Auth.js** — `useSession()`, server-side session helpers
- **Supabase Auth** — `useUser()`, built into the Supabase client

AuthContext.tsx here exists to teach you the Context pattern — how createContext,
useContext, and a custom hook fit together. That knowledge directly applies to
understanding how Clerk/NextAuth work under the hood.

## When to use Context vs a hook
  Context → data needed by many unrelated components (theme, current user)
  Hook    → data tied to a specific feature (tasks, notifications)

## Key rule
Every provider added here must be wired into src/app/layout.tsx.
CONTEXTREADME

cat > src/context/ThemeProvider.tsx << 'THEMEPROVIDER'
// ─── ThemeProvider ────────────────────────────────────────────────────────────
// Wraps next-themes so the whole app supports dark/light mode.
// Imported and used in src/app/layout.tsx.
//
// Full dark mode chain:
//   ThemeProvider (here)
//     └── ThemeToggle reads/writes theme via useTheme()
//           └── next-themes adds/removes 'dark' class on <html>
//                 └── Tailwind dark: variants activate
//                       └── shadcn/ui CSS variables switch automatically

'use client';

import { ThemeProvider as NextThemesProvider } from 'next-themes';

export function ThemeProvider({ children }: { children: React.ReactNode }) {
  return (
    <NextThemesProvider
      attribute="class"      // adds/removes 'dark' class on <html>
      defaultTheme="system"  // respects OS preference by default
      enableSystem
    >
      {children}
    </NextThemesProvider>
  );
}
THEMEPROVIDER
echo "  ✅ src/context/ThemeProvider.tsx"

cat > src/context/AuthContext.tsx << 'AUTHCONTEXT'
// ─── AuthContext ──────────────────────────────────────────────────────────────
// Provides current user and auth state to the whole app.
//
// ⚠️  Honest note — in real projects almost nobody builds auth context from scratch.
// You'd use an auth provider that gives you a hook out of the box:
//
//   Clerk:      const { user, isLoaded } = useUser();
//   NextAuth:   const { data: session } = useSession();
//   Supabase:   const { data: { user } } = useUser();
//
// This file exists to show you the PATTERN — how context is structured,
// how a custom hook wraps useContext, and how providers are composed.
// The shape here (user, isLoading) is exactly what those providers give you,
// just wired up automatically instead of manually.
//
// Usage in any component:
//   const { user, isLoading } = useAuth();

'use client';

import { createContext, useContext, useState } from 'react';
import { type User } from '@/types';

interface AuthContextValue {
  user: User | null;
  isLoading: boolean;
}

const AuthContext = createContext<AuthContextValue | null>(null);

export function AuthProvider({ children }: { children: React.ReactNode }) {
  // Real app: fetch user from your auth provider here
  const [user] = useState<User | null>(null);
  const [isLoading] = useState(false);

  return (
    <AuthContext.Provider value={{ user, isLoading }}>
      {children}
    </AuthContext.Provider>
  );
}

// Always use this hook instead of useContext(AuthContext) directly
// — it gives a clear error if used outside the provider
export function useAuth(): AuthContextValue {
  const context = useContext(AuthContext);
  if (!context) throw new Error('useAuth must be used inside <AuthProvider>');
  return context;
}
AUTHCONTEXT
echo "  ✅ src/context/AuthContext.tsx"

cat > src/context/index.ts << 'CONTEXTBARREL'
export { ThemeProvider } from './ThemeProvider';
export { AuthProvider, useAuth } from './AuthContext';
CONTEXTBARREL
echo "  ✅ src/context/index.ts"

# ============================================================================
# CONFIG
# ============================================================================

echo ""
echo "⚙️  Scaffolding config..."

cat > src/config/_README.md << 'CONFIGREADME'
# config/

App-wide constants. Pure data — no logic, no imports from other src/ folders.

## What goes here
- `site.ts`  — app name, description, nav links

## What does NOT go here
- Environment variables → use process.env directly where needed
- Functions or logic → that belongs in utils/ or lib/

## Key rule
No functions. No imports. Just plain objects and strings.
If it needs logic, it's not config.
CONFIGREADME

cat > src/config/site.ts << 'SITECONFIG'
// ─── Site Config ──────────────────────────────────────────────────────────────
// App-wide constants. Import from here instead of hardcoding strings.
//
// Usage:
//   import { siteConfig } from '@/config/site';
//   <title>{siteConfig.name}</title>

export const siteConfig = {
  name: 'App',
  description: '',

  // Used by Sidebar.tsx and Navbar.tsx — add routes here as your app grows
  nav: [
    { label: 'Dashboard', href: '/dashboard' },
    // { label: 'Settings', href: '/settings' },
    // { label: 'Profile',  href: '/profile' },
  ],
};
SITECONFIG
echo "  ✅ src/config/site.ts"

# ============================================================================
# CONSTANTS
# ============================================================================

echo ""
echo "📌 Scaffolding constants..."

cat > src/constants/routes.ts << 'ROUTES'
// ─── Routes ───────────────────────────────────────────────────────────────────
// All URL strings in one place. Never hardcode paths in components.
//
// Why this matters:
//   If /dashboard moves to /app/dashboard, you change it here once.
//   Without this, you'd search and replace strings across dozens of files.
//
// Usage:
//   import { ROUTES } from '@/constants/routes';
//   <Link href={ROUTES.DASHBOARD}>Dashboard</Link>
//   router.push(ROUTES.LOGIN);
//   redirect(ROUTES.DASHBOARD);

export const ROUTES = {
  HOME:      '/',
  LOGIN:     '/login',
  DASHBOARD: '/dashboard',
  // Add new routes here as your app grows:
  // SETTINGS: '/settings',
  // PROFILE:  '/profile',
} as const;

// TypeScript: derive the type from the values
// Useful for functions that accept a route as a parameter:
//   function navigate(route: Route) { ... }
export type Route = (typeof ROUTES)[keyof typeof ROUTES];
ROUTES
echo "  ✅ src/constants/routes.ts"

cat > src/constants/index.ts << 'CONSTBARREL'
export { ROUTES } from './routes';
export type { Route } from './routes';
CONSTBARREL
echo "  ✅ src/constants/index.ts"

cat > src/constants/_README.md << 'CONSTREADME'
# constants/

App-wide constant values. Pure data — no logic, no imports from other src/ folders.

## What goes here
- `routes.ts`  — all URL strings
- Add more files as needed: `queryKeys.ts`, `config.ts`, `messages.ts`

## What does NOT go here
- Functions or logic → utils/ or lib/
- Environment variables → use process.env directly
- Feature-specific constants → define them in the feature file

## Key rule
Import from here, never hardcode the same string in multiple places.
CONSTREADME
echo "  ✅ src/constants/_README.md"

# ============================================================================
# UTILS
# ============================================================================

echo ""
echo "🛠️  Scaffolding utils..."

cat > src/utils/_README.md << 'UTILSREADME'
# utils/

Pure helper functions. No React. No API. Data in, data out.

## What goes here
- formatDate(date)          — readable date string
- truncate(str, maxLength)  — shorten with ellipsis
- formatCurrency(amount)    — "$1,234.56"

## What does NOT go here
- React hooks → `hooks/`
- API calls → `services/`
- cn() class merging → `lib/utils.ts` (special case, lives there)

## Key rule
Pure functions only: same input = same output, no side effects, no state.
UTILSREADME

cat > src/utils/index.ts << 'UTILSFNS'
// ─── Utility Functions ────────────────────────────────────────────────────────
// Pure helpers. Import what you need:
//   import { formatDate, truncate } from '@/utils';

// Format a date into a readable string e.g. "12 Jan 2025"
export function formatDate(date: Date | string): string {
  return new Date(date).toLocaleDateString('en-AU', {
    day: 'numeric',
    month: 'short',
    year: 'numeric',
  });
}

// Shorten a string and add ellipsis if over maxLength
export function truncate(str: string, maxLength: number): string {
  if (str.length <= maxLength) return str;
  return str.slice(0, maxLength).trimEnd() + '…';
}

// Format a number as a currency string e.g. "$1,234.56"
export function formatCurrency(amount: number, currency = 'USD'): string {
  return new Intl.NumberFormat('en-US', { style: 'currency', currency }).format(amount);
}
UTILSFNS
echo "  ✅ src/utils/index.ts"

# ============================================================================
# STORES (Zustand)
# ============================================================================

echo ""
echo "🗃️  Scaffolding stores..."

cat > src/stores/uiStore.ts << 'UISTORE'
// ─── UI Store (Zustand) ───────────────────────────────────────────────────────
// Global client-side UI state managed with Zustand.
//
// ── What is Zustand? ──────────────────────────────────────────────────────────
// A minimal state management library. Think of it as useState but global —
// any component can read or update it without prop drilling or Context.
//
// ── Context vs Zustand ────────────────────────────────────────────────────────
//   Context      → good for static/slow-changing values (theme, current user)
//                  re-renders ALL consumers when ANY value changes
//   Zustand      → good for frequently-changing UI state (sidebar open, modals)
//                  components only re-render when their specific slice changes
//
// ── What goes in a store vs a hook ────────────────────────────────────────────
//   Zustand store → UI state shared across many unrelated components
//                   e.g. isSidebarOpen, activeModal, selectedItemId
//   useTasks hook → data state tied to a specific feature
//                   e.g. tasks[], loading, error
//
// ── To use Zustand in your project ────────────────────────────────────────────
//   npm install zustand
//   Then import and use like this:
//
//   const isSidebarOpen = useUIStore(state => state.isSidebarOpen);
//   const toggleSidebar = useUIStore(state => state.toggleSidebar);
//
// ── This file ─────────────────────────────────────────────────────────────────
// This is a COMMENTED-OUT example — it won't run without installing Zustand.
// It's here so you can see the pattern when you encounter it in real codebases.
// Uncomment and run `npm install zustand` when you're ready to use it.

/*
import { create } from 'zustand';

interface UIState {
  isSidebarOpen: boolean;
  toggleSidebar: () => void;
  setSidebarOpen: (open: boolean) => void;

  activeModal: string | null;
  openModal: (name: string) => void;
  closeModal: () => void;
}

export const useUIStore = create<UIState>(set => ({
  // State
  isSidebarOpen: true,
  activeModal: null,

  // Actions
  toggleSidebar: () => set(state => ({ isSidebarOpen: !state.isSidebarOpen })),
  setSidebarOpen: (open) => set({ isSidebarOpen: open }),

  openModal:  (name) => set({ activeModal: name }),
  closeModal: ()     => set({ activeModal: null }),
}));
*/

// Placeholder export so this file can be imported without errors
export {};
UISTORE
echo "  ✅ src/stores/uiStore.ts"

cat > src/stores/_README.md << 'STORESREADME'
# stores/

Global client-side state managed with Zustand.
Only use this for UI state that's needed by many unrelated components.

## What goes here
- `uiStore.ts` — sidebar open/closed, active modal, selected item

## What does NOT go here
- Server data (tasks, users) → use hooks (useTasks) or React Query
- Auth state → use your auth provider's hook (useUser, useSession)
- Theme → next-themes handles it via context

## Context vs Zustand

| | Context | Zustand |
|---|---|---|
| Good for | Static values (theme, user) | Frequently-changing UI state |
| Re-renders | All consumers on any change | Only components using changed slice |
| Boilerplate | More | Less |
| DevTools | No | Yes (zustand/middleware) |

## To enable Zustand
```bash
npm install zustand
```
Then uncomment the code in uiStore.ts.

## Naming
`<domain>Store.ts` — uiStore, filterStore, cartStore
STORESREADME
echo "  ✅ src/stores/_README.md"

# ============================================================================
# DOCS
# ============================================================================

echo ""
echo "📖 Writing ARCHITECTURE.md..."

cat > docs/ARCHITECTURE.md << 'ARCH'
# Architecture

A plain-English guide to how this project is structured and why.
**Read this first.** Then open each folder and read its `_README.md`.

---

## What this project is

This is a reference project — not something you build in, but something you
study while building in your actual project. Every folder, file, and pattern
here reflects real-world professional Next.js conventions.

---

## Folder map

\`\`\`
src/
├── app/                  → Next.js router (pages, layouts, API routes)
├── actions/              → Server Actions (server-side mutations, no API route needed)
├── components/
│   ├── layout/           → shell UI: Navbar, Sidebar
│   ├── shared/           → reusable UI: LoadingSpinner, ConfirmDialog, etc.
│   └── features/
│       ├── dashboard/    → DashboardView.tsx — what the dashboard page renders
│       └── tasks/        → TaskCard, TaskList, TaskForm
├── hooks/                → custom React hooks
├── services/             → API call functions (one file per feature)
├── stores/               → global UI state (Zustand) — sidebar, modals, selections
├── lib/
│   ├── utils.ts          → cn() helper
│   └── api/              → base fetch client + endpoint map
├── types/                → shared TypeScript types
├── constants/            → app-wide constant values (routes, keys)
├── context/              → React providers (theme, auth)
├── config/               → app-wide config objects (site name, nav)
├── utils/                → pure helper functions (formatDate, truncate)
└── mocks/                → sample data for development
\`\`\`

---

## The layers rule

Each layer only talks to the layer directly below it:

\`\`\`
pages/components  →  hooks  →  services  →  lib/api  →  API routes  →  database
\`\`\`

Break this and components become impossible to reuse, test, or understand.

---

## Route groups — (auth) and (dashboard)

The parentheses in folder names like \`(auth)\` and \`(dashboard)\` are Next.js **route groups**.

**What they do:** group routes together so they can share a layout, WITHOUT affecting the URL.

\`\`\`
src/app/
├── (auth)/
│   └── login/page.tsx        →  URL: /login      (not /auth/login)
├── (dashboard)/
│   ├── layout.tsx             →  shared layout: Navbar + Sidebar
│   └── dashboard/page.tsx    →  URL: /dashboard   (not /dashboard/dashboard)
\`\`\`

**Why this matters:**
- The \`(dashboard)\` layout wraps ALL pages inside it with Navbar + Sidebar automatically
- The \`(auth)\` group can have its own layout (centered card, no sidebar)
- Without route groups you'd have to import Navbar/Sidebar manually in every page
- Adding a new page like \`/settings\` inside \`(dashboard)\` gets the layout for free

**Key rule:** parentheses = invisible to the URL. The folder is for YOU, not the router.

---

## API Routes vs Server Actions

Two ways to run code on the server in Next.js:

\`\`\`
API Route (app/api/tasks/route.ts)        Server Action (actions/tasks.actions.ts)
────────────────────────────────────       ────────────────────────────────────────
Has a URL: POST /api/tasks                 No URL — direct function call
Called via fetch() in a service            Called directly: await createTask(input)
Works from anywhere (mobile, etc.)         Works from your Next.js app only
More boilerplate                           Less boilerplate
\`\`\`

**When to use which:**
- Server Action → form submissions, simple mutations inside your own app
- API Route → public API, mobile app backend, needs to be called from outside

Both are shown in this project. Study both — you'll encounter both in real codebases.

---

## The feature pattern

Every new feature follows the same order:

```
1. types/        → define the shape (Task, CreateTaskInput)
2. mocks/        → create sample data matching that shape
3. services/     → write the API calls
4. hooks/        → manage state, call the service
5. components/features/<name>/  → build the UI, call the hook
6. app/(dashboard)/<name>/      → add the page
7. app/api/<name>/route.ts      → add the API route
8. config/site.ts               → add to nav
```

Study `tasks` as the example — it follows every step.

---

## app/ — the Next.js router

File location = URL. Key files:

| File | Purpose |
|---|---|
| `layout.tsx` | Wraps every page. Add providers here. Shell only. |
| `page.tsx` | Routing only — one line, imports the View component. |
| `loading.tsx` | Shown automatically while page loads. |
| `error.tsx` | Shown automatically if page throws. |
| `not-found.tsx` | Shown for unknown URLs (one at root is enough). |
| `(auth)/` | Route group — groups login/register without affecting URL. |
| `(dashboard)/` | Route group — groups all authenticated pages. |
| `(dashboard)/layout.tsx` | Shared layout for all dashboard pages (Navbar + Sidebar). |
| `api/tasks/route.ts` | Backend API endpoint — runs on server only. |

## Page vs View — the pattern

```
page.tsx  (routing only)
  └── imports DashboardView

DashboardView.tsx  (owns layout + composition)
  └── max-w-2xl mx-auto p-6 space-y-6
  └── <PageHeader />
  └── <TaskList />
```

**Why split them?**
- `page.tsx` is Next.js's concern — keep it as lean as possible
- `*View.tsx` is your concern — layout, data passing, feature composition
- Views can be tested without the Next.js routing layer
- Consistent: you always know pages are thin, Views have the content

**Naming:** `*View.tsx` signals "this is what a page renders, not a reusable piece."
Some teams use `*Screen.tsx` — same idea.

---

## Dark / light mode

```
ThemeProvider (context/ThemeProvider.tsx)
  └── adds/removes 'dark' class on <html> via next-themes
        └── Tailwind dark: variants activate
              └── shadcn/ui CSS variables switch automatically

ThemeToggle (components/shared/ThemeToggle.tsx)
  └── calls useTheme() from next-themes to read/write the current theme
```

To add dark mode to your own project:
1. `npm install next-themes`
2. Copy `ThemeProvider.tsx` → wrap your layout
3. Copy `ThemeToggle.tsx` → drop it in your Navbar

---

## File naming conventions

| Thing | Convention | Example |
|---|---|---|
| Components | PascalCase | \`TaskCard.tsx\` |
| Hooks | camelCase, starts with \`use\` | \`useTasks.ts\` |
| Services | camelCase + \`.service.ts\` | \`tasks.service.ts\` |
| Actions | camelCase + \`.actions.ts\` | \`tasks.actions.ts\` |
| Types | camelCase (no suffix needed) | \`task.ts\` |
| Mocks | camelCase + \`.mock.ts\` | \`tasks.mock.ts\` |
| Folders | lowercase | \`features/tasks/\` |

---

## src/components/features/ vs src/features/

You'll see two different folder patterns in Next.js projects. This project uses
\`src/components/features/\` — here's how they compare:

**This project: \`src/components/features/tasks/\`**
\`\`\`
components/features/tasks/   → UI components only (TaskCard, TaskList, TaskForm)
hooks/useTasks.ts            → state management
services/tasks.service.ts    → API calls
types/task.ts                → types
\`\`\`
Each concern lives in its own top-level folder. Simple and easy to find things.

**Alternative: \`src/features/tasks/\` (your \`new feature\` scaffold)**
\`\`\`
features/tasks/
├── components/   → TaskCard, TaskList, TaskForm
├── hooks/        → useTasks.ts
├── services/     → tasks.service.ts
├── types/        → task.ts
└── index.ts      → public API
\`\`\`
Everything for one feature lives together. Better for large apps with many features.

**Which to use?**
- Small/medium app (< 5 features) → top-level folders (this project's approach)
- Large app (5+ features, team) → feature folders (\`src/features/\`)

Both are valid. Most real codebases use one or the other consistently.
The patterns you learn here apply to both.

---

## Server vs Client Components

In Next.js App Router, every component is a **Server Component by default**.
This means it runs on the server and has no access to browser APIs.

Add \`'use client'\` at the top of a file when it needs:
- \`useState\`, \`useEffect\`, or any React hook
- Browser APIs (localStorage, window, etc.)
- Event listeners (onClick, onChange, etc.)

**Rule:** keep pages as Server Components. Push \`'use client'\` as far down the
component tree as possible — ideally to small leaf components only.

---

## Adding a new feature (checklist)

- [ ] \`src/types/<feature>.ts\` — define types
- [ ] \`src/mocks/<feature>.mock.ts\` — sample data
- [ ] \`src/mocks/index.ts\` — export it
- [ ] \`src/services/<feature>.service.ts\` — API calls
- [ ] \`src/services/index.ts\` — export it
- [ ] \`src/lib/api/endpoints.ts\` — add URL strings
- [ ] \`src/constants/routes.ts\` — add route string
- [ ] \`src/hooks/use<Feature>.ts\` — state management
- [ ] \`src/components/features/<feature>/\` — UI components
- [ ] \`src/actions/<feature>.actions.ts\` — Server Actions (if needed)
- [ ] `src/app/(dashboard)/<feature>/page.tsx` — route
- [ ] `src/app/(dashboard)/<feature>/loading.tsx` — loading state
- [ ] `src/app/(dashboard)/<feature>/error.tsx` — error boundary
- [ ] `src/app/api/<feature>/route.ts` — API endpoint
- [ ] `src/config/site.ts` — add to nav

---

## The real world stack

This reference project uses a minimal stack (Next.js + shadcn + fetch) to keep
things clear while you're learning. But in professional projects you'll almost
always see these additional tools. This is what they replace:

### React Query (TanStack Query)
**Replaces:** manual `useState` + `useEffect` data fetching in hooks
**What it does:** handles loading, error, caching, and refetching automatically
**You'll see it in:** almost every serious Next.js project
```ts
// Instead of useTasks with useState/useEffect:
const { data: tasks, isLoading } = useQuery({
  queryKey: ['tasks'],
  queryFn: tasksService.getAll,
});
```

### Zod
**Replaces:** manual validation (`if (!body.title) return error`)
**What it does:** validates and types data at runtime — great for API route bodies and forms
**You'll see it in:** API routes, forms (with react-hook-form), anywhere data comes in
```ts
const createTaskSchema = z.object({ title: z.string().min(1) });
const parsed = createTaskSchema.parse(body); // throws if invalid
```

### Prisma (or Drizzle)
**Replaces:** the mock data in this project
**What it does:** typed ORM for querying a real database (PostgreSQL, SQLite, etc.)
**You'll see it in:** any full-stack Next.js app with a database
```ts
const tasks = await prisma.task.findMany({ where: { userId: session.user.id } });
```

### Clerk (or NextAuth / Supabase Auth)
**Replaces:** the empty AuthContext in this project
**What it does:** full authentication — sign up, login, sessions, route protection
**You'll see it in:** any app that has users
```ts
const { userId } = auth(); // Clerk — one line, server or client
```

### tRPC
**Replaces:** the entire `lib/api/`, `services/`, and `app/api/` pattern
**What it does:** end-to-end typed API calls — no REST, no fetch wrapper needed
**You'll see it in:** TypeScript-first teams who want to skip the REST boilerplate
```ts
// No route.ts, no service, no fetch wrapper needed:
const tasks = trpc.tasks.getAll.useQuery();
```

---

### What to learn next (in order)
1. Build a few projects with what's here (Next.js + fetch + shadcn)
2. Add **React Query** — it's the biggest quality-of-life upgrade
3. Add **Zod** — validation is essential once you have real user input
4. Add **Prisma** — once you're ready for a real database
5. Add **an auth provider** (Clerk is the easiest to start with)
6. Explore **tRPC** once you're comfortable with the REST pattern
ARCH
echo "  ✅ docs/ARCHITECTURE.md"

# ============================================================================
# BOILERPLATE CLEANUP
# ============================================================================

echo ""
echo "🧹 Cleaning up boilerplate..."

find public/ -name "*.svg" -delete
rm -f public/favicon.ico src/app/favicon.ico
echo "  ✅ Default SVGs and favicons removed"

echo ""
echo "✨ Adding Prettier config..."
cat > prettier.config.mjs << 'PRETTIER'
/** @type {import('prettier').Config} */
const config = {
  singleQuote: true,
  trailingComma: 'es5',
  printWidth: 100,
  semi: true,
  tabWidth: 2,
  arrowParens: 'avoid',
};

export default config;
PRETTIER
echo "  ✅ prettier.config.mjs"

echo ""
echo "🔐 Creating .env files..."
touch .env.local
cat > .env.example << 'EOF'
# Copy this file to .env.local and fill in the values

# App
NEXT_PUBLIC_APP_URL=http://localhost:3000
NEXT_PUBLIC_API_URL=

# Auth
# NEXTAUTH_SECRET=
# NEXTAUTH_URL=http://localhost:3000

# Database
# DATABASE_URL=

# Third-party
# OPENAI_API_KEY=
EOF
echo "  ✅ .env.local and .env.example"

echo ""
echo "📝 Updating .gitignore..."
cat >> .gitignore << 'GITIGNORE'

# Environment
.env.local
.env.*.local

# macOS
.DS_Store
.AppleDouble
.LSOverride

# Logs
*.log
npm-debug.log*

# Editor
.vscode/settings.json
GITIGNORE
echo "  ✅ .gitignore"

echo ""
echo "🔧 Creating .vscode/settings.json..."
mkdir -p .vscode
cat > .vscode/settings.json << 'VSCODE'
{
  "editor.defaultFormatter": "esbenp.prettier-vscode",
  "editor.formatOnSave": true,
  "editor.codeActionsOnSave": {
    "source.fixAll.eslint": "explicit"
  },
  "tailwindCSS.experimental.classRegex": [
    ["cn\\(([^)]*)\\)", "(?:'|\"|`)([^'\"`]*)(?:'|\"|`)"]
  ],
  "css.lint.unknownAtRules": "ignore"
}
VSCODE
echo "  ✅ .vscode/settings.json"

echo ""
echo "📌 Creating .nvmrc..."
node --version > .nvmrc
echo "  ✅ .nvmrc ($(node --version))"

# ============================================================================
# SHADCN
# ============================================================================

echo ""
echo "🎨 Initialising shadcn/ui..."
npx shadcn@latest init --yes

echo ""
echo "🧩 Installing shadcn components..."
npx shadcn@latest add \
  button input card dialog form select sonner dropdown-menu \
  separator badge avatar tooltip sheet \
  tabs table skeleton alert popover \
  checkbox switch breadcrumb \
  --yes --overwrite
echo "  ✅ All shadcn components installed"

# ============================================================================
# GIT
# ============================================================================

echo ""
echo "🔧 Resetting git to a single clean commit..."
rm -rf .git
git init
git add .
git commit -m "chore: initial reference project setup"
echo "  ✅ Clean initial commit"

# ============================================================================
# OPEN IN VS CODE
# ============================================================================

echo ""
echo "🖥️  Opening in VS Code..."
if command -v code &> /dev/null; then
  code -r .
elif [ -f "/opt/homebrew/bin/code" ]; then
  /opt/homebrew/bin/code -r .
elif [ -f "/usr/local/bin/code" ]; then
  /usr/local/bin/code -r .
else
  open -a "Visual Studio Code" . || echo "⚠️  Could not open VS Code — open manually"
fi

# ============================================================================
# DONE
# ============================================================================

echo ""
echo "✅ Reference project ready!"
echo ""
echo "📍 $TARGET"
echo ""
echo "┌──────────────────────────────────────────────────────┐"
echo "│  src/                                                │"
echo "│  ├── app/                                            │"
echo "│  │   ├── (auth)/login/page.tsx                       │"
echo "│  │   ├── (dashboard)/                                │"
echo "│  │   │   ├── layout.tsx                              │"
echo "│  │   │   └── dashboard/ (page, loading, error)       │"
echo "│  │   ├── api/tasks/route.ts                          │"
echo "│  │   ├── layout.tsx · page.tsx                       │"
echo "│  │   ├── loading.tsx · not-found.tsx                 │"
echo "│  │   └── globals.css                                 │"
echo "│  ├── components/                                     │"
echo "│  │   ├── features/                                   │"
echo "│  │   │   ├── dashboard/DashboardView.tsx             │"
echo "│  │   │   └── tasks/ (TaskCard, TaskList, TaskForm)   │"
echo "│  │   ├── layout/ (Navbar, Sidebar)                   │"
echo "│  │   └── shared/ (PageHeader, ConfirmDialog,         │"
echo "│  │              ThemeToggle, EmptyState, LoadingSpinner│"
echo "│  ├── actions/ (tasks.actions.ts)                     │"
echo "│  ├── hooks/ (useTasks, useDebounce, useLocalStorage) │"
echo "│  ├── services/ (tasks, auth)                         │"
echo "│  ├── stores/ (uiStore — Zustand example)             │"
echo "│  ├── lib/ (utils · api/client · api/endpoints)       │"
echo "│  ├── types/ (task, auth, api)                        │"
echo "│  ├── constants/ (routes.ts)                          │"
echo "│  ├── context/ (ThemeProvider, AuthContext)           │"
echo "│  ├── config/ (site.ts)                               │"
echo "│  ├── utils/ (formatDate, truncate, formatCurrency)   │"
echo "│  └── mocks/ (tasks)                                  │"
echo "│                                                      │"
echo "│  docs/ARCHITECTURE.md                                │"
echo "└──────────────────────────────────────────────────────┘"
echo ""
echo "📖 Start here → docs/ARCHITECTURE.md"
echo "   Then read each folder's _README.md"
echo ""
echo "💡 To start the dev server:"
echo "   cd $TARGET && npm run dev"
echo ""
echo "💡 When ready to push to GitHub:"
echo "   ghcreate"
