# Steering Long Sessions

> How to scope, steer, and automate long Claude Code sessions without losing control.

---

## Two core habits

1. **Scope the work** before Claude starts
2. **Steer it** while it runs

---

## Modes — `Shift + Tab` to cycle

| Mode | Status bar | Description | When to use |
|------|------------|-------------|-------------|
| **Accept edits** | `⏵⏵ accept edits on` | Claude saves all changes automatically | Default — Claude saves without asking |
| **Plan** | `⏸ plan mode on` | Read-only — Claude plans, makes no changes | Before any complex task — always start here |
| **Auto** | `⏵⏵ auto mode on` | Claude works autonomously without asking | You trust Claude with the task |
| **Manual** | `⏸ manual mode on` | Claude asks permission before every action | Sensitive code, unfamiliar codebase |

### Accept edits
![Accept edits mode](../../assets/screenshots/mode-accept-edits.jpeg)

### Plan
![Plan mode](../../assets/screenshots/mode-plan.jpeg)

### Auto
![Auto mode](../../assets/screenshots/mode-auto.jpeg)

### Manual
![Manual mode](../../assets/screenshots/mode-manual.jpeg)

> 💡 Best practice: start in **Plan** mode to review what Claude intends to do, then switch to **Auto** or **Manual** to execute

---

## 1. Scope the work first — Plan Mode

**When:** before starting any long or complex task — always start here before executing anything
**How:** toggle on before giving Claude the task, then describe what you want done

**Steps:**
1. Navigate to your project folder
2. Start Claude Code: `claude`
3. Press `Shift + Tab` until you see `⏸ plan mode on` at the bottom
4. Type your task and press Enter
5. Claude reads your code in **read-only** mode and returns a plan
6. Review the plan — iterate if something is missing or wrong
7. When happy with the plan, press `Shift + Tab` to switch to Auto or Manual to execute
8. To exit Claude Code: `/exit` or `Ctrl + C`

```bash
Shift + Tab               # cycle modes until you see: ⏸ plan mode on
/exit                     # exit Claude Code and return to terminal
```

> ⚠️ Claude makes **no changes** in plan mode — safe to explore without risk
> 💡 Iterating on a plan is much faster than cleaning up a mess after Claude runs

---

## 2. Steer while Claude works

### Compact

**What it does:** summarizes your conversation, replaces it with the summary as new context, and deletes the old messages — freeing up Claude's "working memory" so it can keep going on long tasks

**When to use:** when you are deep into a long session and Claude's context window is getting full

**The risk:** if the summary drops something important, Claude loses track and drifts off course

**The fix:** always add an instruction after `/compact` to tell Claude what to keep

```bash
/compact                                          # ⚠️ risky — Claude decides what to keep
/compact [instruction]                            # ✅ safe — you decide what stays
# e.g. /compact focus on the --version flag implementation
```

**Real example:**

You are working on a CLI tool. You spent 30 minutes debugging a crash, fixed it, and now you are building a new `--version` flag. Your context window is almost full.

❌ Bad:
```
/compact
```
Claude might forget the crash is already fixed and try to fix it again.

✅ Good:
```
/compact the crash in src/cli.ts is already fixed, focus on the --version flag implementation
```
Claude keeps: crash = fixed, current task = --version flag.

> 💡 Think of `/compact` as "clear your desk but keep the notes that matter" — you decide which notes stay

---

### Rewind

**What it does:** takes you back to a previous checkpoint — every user prompt automatically creates a checkpoint you can revert to

**When to use:** when Claude goes in the wrong direction and you want to undo without prompting your way back out

**How to use:** double tap `Escape` on an empty prompt

```bash
Escape + Escape           # open Rewind menu (on empty prompt)
```

**Real example:**

You asked Claude to refactor a function. It went off track and started rewriting half the file. Instead of prompting your way back, you double tap Escape and roll back to before you gave that instruction.

**Rewind menu options:**

| Option | What it does | When to use |
|--------|-------------|-------------|
| Restore code and conversation | Rolls back both files and chat | Claude made wrong changes AND said wrong things |
| Restore conversation | Rolls back chat only, keeps file changes | Keep file changes but restart the conversation |
| Restore code | Rolls back files only, keeps chat | Claude changed wrong files but conversation is still useful |
| Summarize from here | Summarizes everything after this checkpoint | Had a side conversation, want to free up context space |
| Summarize up to here | Summarizes everything before this checkpoint | Long setup phase to compress, keep recent work intact |

> 💡 Think of each prompt as a save point in a video game — Rewind lets you load any of them

---

## 3. Let Claude run more autonomously

Everything above assumes you are hands-on. Goal and Loop let Claude work with less supervision.

### Goal

**What it does:** sets a completion condition — Claude keeps working until a fast evaluator confirms the condition is met. It won't stop just because it thinks it's finished.

**When to use:** when you can describe what "done" looks like better than the steps to get there

**Important constraint:** the condition must be checkable from Claude's actual output — like test results or type checker output

```bash
/goal [condition]         # set completion condition
/goal clear               # cancel active goal
```

**Real example:**

You are fixing a bug in a billing module. Instead of checking every few minutes if tests pass, you set a goal:

```
/goal all tests in src/billing pass and the type checker reports zero errors
```

Claude keeps working — running tests, fixing errors, running again — until both conditions are confirmed. Then it stops.

❌ Bad goal — not checkable from output:
```
/goal the code looks clean and well organised
```

✅ Good goal — checkable from output:
```
/goal all tests pass and there are zero TypeScript errors
```

> 💡 Think of Goal as "don't stop until this is actually done" — Claude won't give up after the first attempt

---

### Loop

**What it does:** runs a prompt on an interval between turns — either fixed or self-paced. Use it to pull something external and act when the state changes.

**When to use:** when you need Claude to watch something external repeatedly — like a CI run, a deploy, or an API response — and react when it changes

```bash
/loop                     # start loop — Claude runs prompt on interval
Escape                    # stop loop
```

**Real example:**

You triggered a deployment and want Claude to check if it succeeded and run follow-up tasks automatically:

```
/loop check if the deployment at staging.myapp.com is live, and when it is, run the smoke tests
```

Claude checks on an interval, waits for the deploy to go live, then runs the smoke tests — without you watching.

> 💡 Think of Loop as "keep checking until something changes, then act"

---

## 4. Run parallel work — Worktrees

**What it does:** gives each Claude session its own independent file tree so multiple agents can work on the same codebase without conflicts

**The problem without worktrees:** two Claude sessions fighting over the same files = conflicts, like two people editing the same document at the same time

```bash
/worktree                 # manage worktrees
```

When a session exits, its worktree is automatically cleaned up.

**Real example:**

You want Claude to work on two features simultaneously — a new search feature and a billing bug fix.

With worktrees:
- Session 1 → own file tree → works on search feature
- Session 2 → own file tree → works on billing bug fix
- Neither overwrites the other's changes
- Both worktrees removed automatically when sessions exit

**The `.worktreeinclude` file:**

Some files are git-ignored (like `.env`) but needed in every worktree. List them in `.worktreeinclude` at repo root:

```bash
# .worktreeinclude
.env
config.local.json
```

They will be automatically copied into each new worktree.

> 💡 Think of worktrees as "separate desks for each agent" — everyone has their own workspace

---

## Putting it all together

| Habit | Command | When |
|-------|---------|------|
| Scope first | `Shift + Tab` → Plan mode | Before every complex task |
| Compact with direction | `/compact [instruction]` | Context window getting full |
| Rewind when lost | `Escape + Escape` | Claude went wrong direction |
| Set a finish line | `/goal [condition]` | You know what "done" looks like |
| Watch external changes | `/loop` | Waiting for CI, deploy, API |
| Parallelize safely | `/worktree` | Multiple agents, same codebase |

> 💡 Do that, and you can trust a long run without babysitting every step of it.

---

*Last updated: August 2026*
