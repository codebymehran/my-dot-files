# ARCHITECTURE PLAN

---

## AI Mentor Prompt

> The user has shared this architecture planning document with you. They are preparing to build a new project and want to complete all planning before writing a single line of code. Your role is to guide them through this document as a structured planning session.

```
You are an expert coding mentor. I am a complete beginner learning Next.js (App Router), React, 
Shadcn UI and TypeScript. I have shared this architecture planning document with you.
I want to complete all planning before writing a single line of code.
Your role is to guide me through this document as a structured planning session.

My stack (always use these when giving examples or guidance):
- Next.js latest — App Router only, no Pages Router, use Server Components by default
- React — hooks, functional components only
- TypeScript — strict mode. I am very new to TypeScript so whenever a field, prop, state value,
  or function comes up that has a type, explain the TypeScript type I should use, why that type
  is correct, and show me a short example. Never assume I know a type — always explain it.
- Shadcn UI — when a UI element comes up (buttons, inputs, modals, forms, tables etc.),
  suggest the appropriate Shadcn component and briefly explain why it fits

Session rules:
- Ask me one question at a time and wait for my answer before moving on
- Never fill in the answer for me — ask questions that guide me to the answer myself
- If I am wrong, correct me clearly, explain why, and give a beginner-friendly example
- Never jump ahead — do not move to the next section or question until the current one is complete
- Keep all explanations simple and beginner-friendly — no jargon without explanation

Follow this exact section order:
  1. Before any code: Section 1, 2, 3, 11
  2. Per feature (repeat for each feature): Section 4, 5, 5b, 7, 8
  3. Only if needed: Section 6, 9

Key rules to enforce throughout:
- Section 3 is for ENTITIES only — things with multiple fields that get created, stored and 
  displayed (e.g. a Post, a User, an Order). If it only has one value it is not an entity.
- Section 4 is for ALL OTHER STATE — simple values like selected filter, loading boolean, 
  search string, active tab. These are not entities.
- Always fill Section 4 (state) before Section 5 (components) — you cannot design components
  without knowing what state they need to hold or receive
- Derived state is NEVER stored — if a value can be calculated from existing state, it must 
  be computed on the fly, never put in useState. Always challenge me: "can this be derived?"
- For every piece of state ask me two questions: who owns this state? and can this be derived?
- The distinction between entities (Section 3) and simple state (Section 4) is the most common 
  place beginners get confused. If I seem unsure, do not just correct me — ask me "why do you 
  think this is an entity and not just state?" or "why can't we just store this?" and let me 
  reason through it. That back-and-forth is where the real learning happens.

When we reach Section 5, always remind me:
- Use Server Components by default in Next.js App Router
- Only add "use client" when the component needs interactivity, state or browser APIs
- Suggest Shadcn UI components where appropriate

Start by introducing yourself briefly, then ask me for my project name to begin Section 1.
```

---

> **How to use this in VSCode:**
> Open this file → press `Cmd/Ctrl + Shift + V` to open the Markdown preview side-by-side.
> Edit on the left, see it render on the right.

---

## Before you write a single line of code, answer these two questions:

**1. What data does this app need to REMEMBER?**

>

**2. What can be COMPUTED from that data? (never store computed values)**

>

---

**Project name:** _________
**Date started:** _________
**Date finished:** _________

---

## When to fill each section

| When | Sections |
| ---- | -------- |
| Before any code (fill once) | 1. Product Description · 2. Pages & Routes · 3. Data Shape · 11. Build Order |
| Per feature (fill as you build) | 4. State · 5. Component Tree · 5b. Responsibilities · 7. Data Flow · 8. Handlers · 10. Checklist |
| Only if needed | 6. Context (prop drilling) · 9. API Plan (fetching data) |

---

## 1. Product Description

> Plain English only - no tech terms. What does it do, who uses it, what problem does it solve?

| Question | Answer |
| -------- | ------ |
| What does it do? | |
| Who uses it? | |
| What problem does it solve? | |

---

## 2. Pages and Routes

> New screen = layout changes completely + back button makes sense + its own URL. Otherwise it is just a state change.

| Route | Page name | What it shows | Server or Client? |
| ----- | --------- | ------------- | ----------------- |
| `/`   |           |               |                   |
|       |           |               |                   |
|       |           |               |                   |
|       |           |               |                   |

**Decision guide:**
- Display data only → server component (no `'use client'`)
- Forms, interactions, state → client component

---

## 3. Data Shape

> Entities only — things with multiple fields that the user creates or the app stores.
> Simple values like a selected filter or a boolean flag belong in Section 4, not here.

```ts
// Entity:
{
  id:
  // field:   type
}
```

```ts
// Entity:
{
  id:
  // field:   type
}
```

```ts
// Entity:
{
  id:
  // field:   type
}
```

---

## 4. State Inventory

> State = any value that changes over time and affects what the user sees.
> Ask first: can I COMPUTE this from existing state? If yes - never store it.

| State | Kind | Owned by |
| ----- | ---- | -------- |
|       |      |          |
|       |      |          |
|       |      |          |
|       |      |          |
|       |      |          |
|       |      |          |
|       |      |          |
|       |      |          |

**State kind guide:**
- **True state** — changes over time, lives in `useState` or `useReducer`
- **Local UI state** — only affects one component (open/closed, active tab)
- **Derived** — computed from other state, NEVER stored
- **Server state** — comes from an API, lives in fetch + loading + error pattern
- **Global state** — needed 3+ levels deep, belongs in Context

---

## 5. Component Tree

> Fill in component/file names under each folder. Standard Next.js project layout.
> Always fill Section 4 (State) before this section.

```
src/
  app/                       Next.js file-based routing - one folder = one route
    (routes)/                route groups - group pages without affecting URL
      ___________________________
      ___________________________
      ___________________________
    layout.tsx               root layout - wraps every page (nav, fonts, providers)
    page.tsx                 home page
    loading.tsx              automatic loading UI while page fetches
    error.tsx                automatic error boundary for this route

  features/                  one folder per feature - self-contained vertical slices

    feature 1: _____________/
      components/            UI only for this feature
        ___________________________
        ___________________________
        ___________________________
        ___________________________
        ___________________________
      hooks/                 custom hooks for this feature
        ___________________________
        ___________________________
        ___________________________
      utils/                 helpers scoped to this feature
        ___________________________
        ___________________________
      types.ts               TypeScript types for this feature
      index.ts               public API - only export what other features need

    feature 2: _____________/
      components/
        ___________________________
        ___________________________
        ___________________________
        ___________________________
        ___________________________
      hooks/
        ___________________________
        ___________________________
        ___________________________
      utils/
        ___________________________
        ___________________________
      types.ts
      index.ts

    feature 3: _____________/
      components/
        ___________________________
        ___________________________
        ___________________________
        ___________________________
        ___________________________
      hooks/
        ___________________________
        ___________________________
        ___________________________
      utils/
        ___________________________
        ___________________________
      types.ts
      index.ts

    feature 4: _____________/
      components/
        ___________________________
        ___________________________
        ___________________________
        ___________________________
        ___________________________
      hooks/
        ___________________________
        ___________________________
        ___________________________
      utils/
        ___________________________
        ___________________________
      types.ts
      index.ts

    feature 5: _____________/
      components/
        ___________________________
        ___________________________
        ___________________________
        ___________________________
        ___________________________
      hooks/
        ___________________________
        ___________________________
        ___________________________
      utils/
        ___________________________
        ___________________________
      types.ts
      index.ts

    feature 6: _____________/
      components/
        ___________________________
        ___________________________
        ___________________________
        ___________________________
        ___________________________
      hooks/
        ___________________________
        ___________________________
        ___________________________
      utils/
        ___________________________
        ___________________________
      types.ts
      index.ts

  shared/                    truly reusable code - used by 2+ features
    ui/                      generic UI components (Button, Modal, Input...)
      ___________________________
      ___________________________
      ___________________________
      ___________________________
      ___________________________
    hooks/                   reusable hooks (useDebounce, useLocalStorage...)
      ___________________________
      ___________________________
      ___________________________
    utils/                   pure helper functions (formatDate, cn...)
      ___________________________
      ___________________________
    types/                   shared TypeScript types and interfaces
      ___________________________
      ___________________________
    constants/               app-wide constants (routes, config, enums)
      ___________________________
      ___________________________

  lib/                       third-party config and initialisation
    ___________________________
    ___________________________
    ___________________________

  store/                     global state - only if needed (Zustand, Redux...)
    ___________________________
    ___________________________
    ___________________________

  styles/                    global CSS, Tailwind base, design tokens
    ___________________________
    ___________________________

  public/                    static assets served at / (images, fonts, icons)
    ___________________________
    ___________________________
```

---

## 5b. Component Responsibilities

> Each component has ONE job. If "what it does" contains "and" - split it.
> Start description with a verb: renders, displays, handles, calculates, manages.

| Component | What it does (verb first) | UI elements inside |
| --------- | ------------------------- | ------------------ |
|           |                           |                    |
|           |                           |                    |
|           |                           |                    |
|           |                           |                    |
|           |                           |                    |
|           |                           |                    |
|           |                           |                    |
|           |                           |                    |
|           |                           |                    |
|           |                           |                    |

---

## 6. Context Candidates — only if needed

> Only use Context if state travels 3+ levels deep. 1-2 levels → just pass props.

| State | Context name | Why it needs Context |
| ----- | ------------ | -------------------- |
|       |              |                      |
|       |              |                      |
|       |              |                      |
|       |              |                      |

---

## 7. Data Flow Map

> Data flows DOWN (props). Events flow UP (callbacks named `onX`).

| Component | Props it receives (data down) | Callbacks it receives (events up) |
| --------- | ----------------------------- | --------------------------------- |
|           |                               |                                   |
|           |                               |                                   |
|           |                               |                                   |
|           |                               |                                   |
|           |                               |                                   |
|           |                               |                                   |
|           |                               |                                   |
|           |                               |                                   |

---

## 8. Handler Inventory

> Naming rule: `handleX` in the component, passed down as `onX` prop.

| Handler | What it does | Lives in |
| ------- | ------------ | -------- |
|         |              |          |
|         |              |          |
|         |              |          |
|         |              |          |
|         |              |          |
|         |              |          |
|         |              |          |
|         |              |          |

---

## 9. API / Data Fetching Plan — only if needed

> Always plan three states: loading, success, error. Never just the happy path.

| Data | Fetched where | Method | Loading state? | Error handling |
| ---- | ------------- | ------ | -------------- | -------------- |
|      |               |        |                |                |
|      |               |        |                |                |
|      |               |        |                |                |
|      |               |        |                |                |
|      |               |        |                |                |

---

## 10. Checklist — Before Writing Each Feature

- [ ] Do I know what state I need?
- [ ] Is this true state, derived state, or server state?
- [ ] Which component is the lowest common ancestor - who owns the state?
- [ ] Am I mutating or copying? (always copy - spread, map, filter)
- [ ] What props go down? What callbacks go up?
- [ ] Does any state need Context, or can I just pass props?
- [ ] Is this component server or client?
- [ ] Does this logic belong in `features/` or `shared/`?
- [ ] Have I handled loading state?
- [ ] Have I handled error state?

---

## 11. Build Order

> Always static before interactive. Never start a new feature until the current one works end to end.
> User must act (click / type / submit) → **Interactive** · It just appears on screen → **Static**

| # | Feature | Static or Interactive? | Depends on |
| - | ------- | ---------------------- | ---------- |
|   |         |                        | Nothing    |
|   |         |                        |            |
|   |         |                        |            |
|   |         |                        |            |
|   |         |                        |            |
|   |         |                        |            |
|   |         |                        |            |
|   |         |                        |            |
|   |         |                        |            |
|   |         |                        |            |
|   |         |                        |            |
|   |         |                        |            |

---

## 11.5 Git Strategy

> Branch: `feature/short-name` · Commit: `type: description` (present tense)
> Types: `feat` `fix` `refactor` `docs` `style` `chore`

| Feature | Branch name | Commit message |
| ------- | ----------- | -------------- |
|         |             |                |
|         |             |                |
|         |             |                |
|         |             |                |
|         |             |                |
|         |             |                |
|         |             |                |
|         |             |                |
|         |             |                |
|         |             |                |
|         |             |                |
|         |             |                |

---

## 11.6 Commit Checklist

- [ ] Does the feature work end-to-end?
- [ ] Are there any console errors?
- [ ] Is the commit message formatted as `type: description` (present tense)?
- [ ] Am I on the correct branch?

---

## Notes & Decisions

> Decisions, open questions, things that confused you, anything that does not fit above.

&nbsp;

&nbsp;

&nbsp;

&nbsp;

&nbsp;

&nbsp;

&nbsp;

&nbsp;

&nbsp;

&nbsp;
