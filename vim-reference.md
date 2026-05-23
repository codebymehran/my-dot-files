# 📚 Vim Reference Guide
> `Cmd+Shift+,` to open · `Cmd+Shift+V` to toggle preview

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

## ⚠️ How MY Vim Differs From Standard
> Online tutorials use vanilla Vim — your setup is customised. Don't get confused.

| Key | Standard Vim | YOUR setup |
|-----|-------------|------------|
| `J` | join lines | **5j** (jump 5 down) |
| `K` | show man page | **5k** (jump 5 up) |
| `H` | jump to top of screen | **`^`** (line start) |
| `L` | jump to bottom of screen | **`$`** (line end) |
| `B` | word back | **Ctrl+v** (visual block) |
| `U` | undo line | **Ctrl+r** (redo) ⭐ |
| `p` in visual | paste (ruins clipboard) | **paste + re-yank** (clipboard safe!) ⭐ |
| `n/N` | next search result | next result **+ centers screen** |
| `* / #` | search word | search word **+ centers screen** |
| `{ / }` | jump paragraph | jump paragraph **+ centers screen** |
| `> / <` | indent (drops selection) | indent **+ keeps selection** ⭐ |
| `gc` | (plugin) comment | comment line (visual mode) |
| `Space` | move right | **leader key** (all your shortcuts) |

---

## 🎯 I Want To...
> Instant lookup — find your situation, use the shortcut

### ✏️ General Editing

| I want to... | Do this |
|---|---|
| Change a word (cursor anywhere on it) | `ciw` |
| Delete a word without ruining clipboard | `"_diw` |
| Change everything inside quotes | `ci"` or `ci'` |
| Change everything inside brackets | `ci(` or `ci{` or `ci[` |
| Change everything inside a JSX/HTML tag | `cit` |
| Replace a word with what I copied | `griw` ⭐ |
| Paste without losing clipboard | `p` in visual mode (auto re-yanks) ⭐ |
| Paste my last YANK (not last delete) | `"0p` ⭐ |
| Delete without ruining clipboard | `"_dd` or `"_diw` |
| Duplicate a line | `Space+d` |
| Move a line up / down | `Space+k` / `Space+j` |
| Undo / redo | `u` / `U` ⭐ |
| Comment / uncomment | `gc` (visual) · `gcc` (visual, stay normal) |
| Select a word | `viw` |
| Select inside quotes | `vi"` |
| Select inside brackets | `vi(` |
| Yank a whole line | `yy` |
| Delete a whole line | `dd` |
| Change from cursor to end of line | `C` |
| Delete from cursor to end of line | `D` |
| Join line below onto current line | `gJ` (standard J is remapped) |
| Indent / un-indent (keep selection) | `>` / `<` ⭐ |
| Repeat last change | `.` ⭐ |
| Multi-edit same word (adjacent) | `gb` → keep pressing → edit |
| Replace scattered occurrences | `*` → `cgn` → type → `Esc` → `.` `.` |
| Jump to matching bracket | `%` |
| Jump to start / end of file | `gg` / `G` |
| Jump 5 lines down / up | `J` / `K` ⭐ |
| Jump to line start / end | `H` / `L` ⭐ |
| Jump to a character on current line | `f<char>` |
| Jump anywhere visible (2 chars) | `s<xx>` |
| Go to line number | `:<number>` |
| Search in file | `/searchterm` then `n` / `N` |
| Clear search highlight | `Space+/` |
| Open any file fast | `Space+p` |
| Find text across all files | `Space+f` |
| Save file | `Space+w` or `Cmd+s` |
| Close file | `Space+q` or `Cmd+w` |

---

### ⚛️ React / Next.js Components

| I want to... | Do this |
|---|---|
| Jump to a component's definition | `gd` on component name |
| Come back after jumping | ` `` ` (backtick backtick) ⭐ |
| See where a component is used | `gr` on component name |
| Peek definition without leaving file | `gD` on component name |
| Rename a component everywhere | `Space+n` on component name |
| Check usages before renaming | `Space+m` first, then `Space+n` |
| Fix a missing import | `Space+a` → select fix |
| Organise / clean up imports | `Space+i` |
| Format the whole file | `Space+;` |
| Change a prop name | `ciw` on the prop |
| Change a JSX attribute value | `ci"` on the value |
| Change what's inside a JSX tag | `cit` |
| Delete a JSX attribute cleanly | `daw` |
| Wrap selection in JSX tag | visual select → `St` → type tag |
| Change a JSX tag name | `cit` then type new tag |
| Remove surrounding JSX tag | `dst` |
| Hover to see prop types | `gh` |
| Jump to a hook's definition | `gd` on hook name |
| See all places a hook is used | `gr` on hook name |
| Change a function argument | `cia` |
| Delete a function argument (+ comma) | `daa` |
| See how many places use a function | CodeLens shows "X references" above it |

---

### 🟦 TypeScript Types & Interfaces

| I want to... | Do this |
|---|---|
| Jump to a type's definition | `gd` on the type name |
| See where a type is used | `gr` on the type name |
| Rename a type everywhere | `Space+n` on the type name |
| Change a type in a union | `ciw` on the type |
| Change a generic type parameter | `ci<` |
| Change a string literal type | `ci"` |
| Hover to see inferred type | `gh` |
| Jump to next / prev type error | `]d` / `[d` |
| Quick fix a type error | `Space+a` |
| Change an interface property name | `ciw` on the property |
| Change an interface property type | `ciw` on the type after `:` |
| Delete an interface property line | `dd` |
| Replace a type with yanked one | `griw` |

---

### 🪟 Splits & Navigation

| I want to... | Do this |
|---|---|
| Split editor side by side | `Cmd+\` or `Space+v` |
| Split editor below | `Cmd+Shift+\` or `Space+\` |
| Move between splits | `Ctrl+h/j/k/l` |
| Close current split | `Ctrl+w q` |
| Maximise current editor | `Ctrl+Shift+B` |
| Toggle file explorer | `Space+e` |
| Next / prev tab | `Tab` / `Shift+Tab` |
| Open vim reference (this file) | `Cmd+Shift+,` |

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
g;    back in change list  g,   forward in change list
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

## ⚠️ Clipboard Gotchas
> Standard Vim problem — but your setup already solves most of it

**The standard Vim trap:**
```
yiw    yank "foo"          ✅ clipboard = "foo"
daw    delete "bar"        ❌ clipboard = "bar" (ruined!)
p      pastes "bar"        😱 wrong!
```

**Your setup already fixes visual paste:**
```js
// YOUR p in visual mode = paste + re-yank automatically ⭐
// So: viw p  →  pastes AND keeps clipboard intact
```

**Still useful to know:**
```
"_daw   delete without touching clipboard  ⭐
"_dd    delete line without touching clipboard
"0p     paste last YANK (not last delete)  ⭐
```

**Replace word with yanked text (safest options):**
```
griw        cleanest — replace word, clipboard safe    ✅ use this
viw p       paste over selection — YOUR p re-yanks     ✅ also safe
viw "0p     explicit yank register — always works      ✅ belt and braces
```

**Mental model:**
```
p     = paste last DELETE or YANK   (risky in standard Vim, safe in yours visually)
"0p   = paste last YANK only        (always safe) ⭐
"_d   = delete to blackhole         (always safe) ⭐
griw  = replace without any risk    (always safe) ⭐
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

**Multi-cursor (adjacent):** `gb` → keep pressing → edit all
> `Space+m` first to confirm refs, then `gb`

**Scattered replace:** `*` → `cgn` → type → `Esc` → `.` `.` `.`

**Safe rename across project:** `Space+n` (uses LSP — renames imports too)

**Fix a broken import:** `Space+a` → select fix

**Jump back after `gd`:** ` `` ` — toggles last 2 positions ⭐

**Visual block edit (multiple lines):** `B` → select → `I` → type → `Esc`

---

## ⚡ Speed Tips
```
ciw          edit any word (no need to move to start)
ci" / ci'    edit any string (cursor anywhere inside)
H / L        line start / end (your remaps) ⭐
J / K        5 lines down / up (your remaps) ⭐
"_d          delete without ruining clipboard ⭐
"0p          paste your last YANK not last delete ⭐
griw         replace word safely (no clipboard loss)
viw p        paste over word — your p re-yanks ⭐
Space+p      open any file in < 2s
Space+n      rename symbol everywhere (safe refactor)
gb           multi-edit adjacent occurrences
cgn + .      multi-edit scattered occurrences
gc           toggle comment (visual mode)
gh           hover info / type without leaving keyboard
``           jump back after gd ⭐
U            redo (your remap) ⭐
B            visual block mode (your remap) ⭐
```

---

## 📚 Shortcuts Reference

**Movement (YOUR remaps)**
```
h j k l      left/down/up/right
J / K        5 lines down / up  ⭐ (remapped)
H / L        line start / end   ⭐ (remapped)
w / b / e    word segments (CamelCase aware)
{ / }        jump blank lines + center
gg / G       top / bottom of file
f<c>         jump to char on line
s<xx>        sneak to any 2-char sequence
%            matching bracket
```

**Undo/Redo:** `u` undo · `U` redo ⭐ (remapped)
**Visual block:** `B` ⭐ (remapped from Ctrl+v)
**Escape insert:** `jj`

**Workspace**
```
Space+e  explorer      Space+p  quick open     Space+f  find in files
Space+r  recent        Space+b  sidebar        Space+z  zen mode
Space+/  clear search  Tab      next tab        S-Tab    prev tab
```

**Terminal**
```
Space+t   toggle    Space+tv  split V    Space+ts  split H
Space+tn  new       Space+tk  kill
```

**File**
```
Space+w  save      Space+q   close       Space+qa  close saved
Space+o  close others        Space+d     duplicate line
Space+c  copy file contents  Space+x     replace file with clipboard
```

**Code**
```
Space+a  quick fix    Space+n  rename       Space+s  symbols
Space+m  references   Space+;  format       Space+i  organise imports
Space+j  move line ↓  Space+k  move line ↑
```

**Go To**
```
gd  definition    gD  peek def      gr  references    gI  implementation
gh  hover/types   gi  last insert   g;  nav back       g,  nav forward
``  toggle last 2 positions ⭐
```

**Errors**
```
]d  next error / warning      [d  prev error / warning
Space+a  quick fix on error
```

**Splits**
```
Space+v      split right    Space+\      split down
Cmd+\        split right    Cmd+Shift+\  split down
Ctrl+h/j/k/l navigate splits
Ctrl+w q     close split    Ctrl+Shift+B maximise editor
```

**Folds**
```
zo / zc    open / close fold
zO / zC    open / close ALL folds
```

**Git**
```
Space+gs  SCM panel    Space+gc  commit    Space+gp  push    Space+gP  pull
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
Quote style     single            Print width     100
```
**Python mode:** set `python.languageServer` → `"Pylance"` · `diagnosticMode` → `"workspace"`

---

## 📝 Today I Learned
<!-- newest first -->

---

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
