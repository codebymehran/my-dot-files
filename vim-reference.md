# 📚 Vim Reference Guide
> `Cmd+Shift+V` to preview · `Space+p` → `vim-ref` to open

---

## 🎓 Learning Path
| # | Topic | Status |
|---|-------|--------|
| 1 | Movement — `hjkl` `H/L` `J/K` `w/b/e` `{/}` `gg/G` `f` sneak | needs drilling |
| 2 | Text Objects — `ciw` `ci"` `ci(` `daw` `diw` `yi"` | needs drilling |
| 3 | Operators + Counts — `3yy` `5dd` `d3w` `c2w` | needs drilling |
| 4 | Marks & Jumps — `ma` `` `a `` ` `` ` `gi` | needs drilling |
| 4.5 | Sneak · CamelCase Motion · Visual Star | needs drilling |
| 5 | Dot Repeat — `.` `cgn+.` | needs drilling |
| 6 | Registers — `"ayy` `"_d` `griw` | needs drilling |
| 7 | Macros — `qa` `@a` `@@` | not started |

---

## 🎯 Text Objects
> Pattern: `verb` + `i/a` + `target` — think *what* to change, not *where* to move
> `i` = inside · `a` = around · verbs: `c` change, `d` delete, `y` yank

```
ciw   change word (anywhere on it)    ci"  change inside "quotes"
daw   delete word + space             ci'  change inside 'quotes'
diw   delete word, keep space         ci(  change inside (parens)
yi"   yank inside quotes              ci{  change inside {braces}
di"   delete inside quotes            cit  change inside <tag>
```
```js
const name = "Alice"          // ci"  → change value
function greet(userName)      // ci(  → change arg
const obj = { key: "val" }   // ciw  → change key
import { A, B, C } from ...  // daw  → remove B cleanly
```

---

## 🔢 Operators + Counts
```
3yy  copy 3 lines    5dd  delete 5 lines    d3w  delete 3 words    c2w  change 2 words
```
> `number + verb + motion` = precise editing

---

## 📍 Marks & Jumps
```
ma    set mark a          `a   jump to mark a (exact)     'a   jump to line of mark a
``    toggle last 2 pos ⭐  gi   last insert point          :marks  show all marks
g;    back in history      g,   forward in history
```

---

## 🏃 Sneak · CamelCase · Visual Star

**Sneak** — `s<xx>` jump to any 2-char sequence · `;` repeat forward · `,` repeat back · `S<xx>` backwards
> Can see it → sneak. Can't see it → `/search`

**CamelCase** — `w/b/e` now move through *segments* inside words
```js
// getUserProfile  →  g·w·User·w·Profile   (w jumps each segment)
// user_profile    →  user·w·profile        (same for snake_case)
// ciw on a segment changes only that segment
```

**Visual Star** — select text → `*` → search that exact selection (vs normal `*` = single word only)

---

## ⏱️ Dot Repeat
```
.                             → repeat last change
* → cgn → type → Esc → . .   → scattered replace (power combo)
```
> `gb` for adjacent occurrences · `cgn+.` for scattered ones

---

## 📋 Registers
```
"ayy   yank line → reg a       "ap   paste reg a        :reg   show all
"byiw  yank word → reg b       "_d   delete, no clip ⭐
```
**Replace With Register** — yank once, replace many without losing clipboard
```
griw   replace word     gri"   replace inside quotes
gri(   replace parens   grit   replace inside tag
```

---

## 🎬 Macros
```
qa  start recording    q   stop    @a  replay    @@  replay last    5@a  replay ×5
```
> Use when dot repeat can't handle multi-step edits

---

## 🧩 Argument Objects
```
cia  change arg (respects commas)    daa  delete arg + comma    yia  yank arg
```

---

## 🔀 Surround (`vim.surround`)
**Visual** (reliable ✅) — select → `S"` `S'` `S(` `S)` `S{` `St`
**Normal** — `cs"'` change · `ds"` delete · `dst` delete tag · (`ys` flaky ❌ → use visual instead)

---

## 🚀 Workflows

**Copy entire file to another:**
`Space+c` → `Tab` to target → `Space+x`

**Multi-cursor:** `gb` add next occurrence · keep pressing · edit all
> `Space+m` first to confirm refs, then `gb`

**Scattered replace:** `*` → `cgn` → type → `Esc` → `.` `.` `.`

---

## ⚡ Speed Tips
```
ciw          edit any word (no need to move to start)
ci" / ci'    edit any string (cursor anywhere inside)
Space+p      open any file in < 2s
Space+n      rename symbol everywhere
gb           multi-edit adjacent occurrences
cgn + .      multi-edit scattered occurrences
gc           toggle comment (visual mode)
gh           hover info without leaving keyboard
```

---

## 📚 Shortcuts Reference

**Movement**
```
h j k l      left/down/up/right        H / L      line start / end
J / K        5 lines down / up         w / b / e  word segments
{ / }        jump blank lines          gg / G     top / bottom
f<c>         jump to char              s<xx>      sneak anywhere
%            matching bracket
```

**Undo/Redo:** `u` undo ⭐ · `U` redo · (not Cmd+Z)
**Escape insert:** `jj`

**Workspace**
```
Space+e  explorer      Space+p  quick open     Space+f  find in files
Space+r  recent        Space+b  sidebar        Space+z  zen mode
Tab      next tab      S-Tab    prev tab
```

**Terminal**
```
Space+t   toggle    Space+tv  split V    Space+ts  split H
Space+tn  new       Space+tk  kill
```

**File**
```
Space+w  save    Space+q  close    Space+qa  close saved    Space+o  close others
Space+c  copy file    Space+x  replace file    Space+d  duplicate line
```

**Code**
```
Space+a  quick fix    Space+n  rename       Space+s  symbols
Space+m  references   Space+;  format       Space+i  organize imports
Space+j  move down    Space+k  move up
```

**Go To**
```
gd  definition    gD  peek def      gr  references    gI  implementation
gh  hover         gf  file          gi  last insert ✅
g;  back          g,  forward
```

**Splits / Folds / Errors / Git**
```
Space+v  split →    Space+\  split ↓    Ctrl+h/j/k/l  navigate splits
zo/zc    fold open/close    zO/zC  all open/close
]d / [d  next/prev error
Space+gs  status    Space+gc  commit    Space+gp  push    Space+gP  pull
```

---

## 🖊️ Colorful Comments
```
//!   🔴 red bold      — warnings          //?   🟣 purple italic — questions
//*   🟢 green         — important         // todo  🟠 orange     — tasks
// ===  🔵 blue bold   — major sections    // ---   🩵 teal bold  — subsections
// //  ~~strikethrough~~ — dead code       // @   🟡 yellow       — references
// +  🟢 additions     // -  🔴 removals
```

---

## 💡 Extensions
**JS/React:** Prettier ✅ · ESLint ✅ · Error Lens ✅ · Colorful Comments ✅ · Turbo Console Log · Alternator
**Python:** Python ✅ · Pylance ✅ (off) · Black ✅ · isort ✅ · autoDocstring (`Cmd+Shift+2`)
**General:** VSCodeVim ✅ · vscode-icons ✅ · GitLens · VSCode Harpoon (install when cycling same files)

---

## ⚙️ Settings Quick Ref
```
Auto-save       2s delay          Line numbers    relative
Formatters      Prettier / Black  Sticky scroll   3 lines
Minimap         off               Cursor context  8 lines
Word wrap       on                Vim thread      isolated (affinity)
Format on paste off               Letter spacing  0.5 · Padding 16px
```
**Python mode:** set `python.languageServer` → `"Pylance"` · `diagnosticMode` → `"workspace"`

---

## 📝 Today I Learned
<!-- newest first -->

## 🔧 Broken / To Investigate
<!-- things that didn't work as expected -->

---

## 🤖 Claude Prompt — Vim Quiz
> Paste this into Claude along with your settings.json to start a quiz session

```
Here is my VSCode settings.json file. I want you to help me master my Vim motions.

Please do the following:
1. Quiz me on Vim motions and bindings ONE BY ONE — wait for my answer before continuing
2. For every question, provide a code snippet with a comment above describing exactly what to do
   e.g. // Move cursor anywhere inside "hello" and delete it + the quotes, ready to type replacement
3. If I get it wrong, correct me, explain why, then give me a NEW snippet to practice the correct motion
4. Focus on things I might not be using or might have forgotten
5. After the quiz, ask if I want to focus on a specific stage from my learning path
6. If you notice any broken bindings or improvements, tell me at the end
7. Keep it conversational and fun — one question at a time

My current Vim stage progress:
- Stage 1 Movement — needs drilling
- Stage 2 Text Objects — needs drilling
- Stage 3 Operators + Counts — needs drilling
- Stage 4 Marks & Jumps — needs drilling
- Stage 5 Dot Repeat — needs drilling
- Stage 6 Registers — needs drilling
- Stage 7 Macros — not started

ps: if you see ✅ on a stage, skip it
```
