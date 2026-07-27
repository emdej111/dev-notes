# Claude Code — Quick Reference ⚡

---

## Getting Started

```bash
claude                    # start Claude Code in current directory
claude --version          # check installed version
```

---

## Basic Commands

```bash
/help                     # list all available commands
/init                     # create CLAUDE.md — instructions Claude always follows
/model                    # switch model — e.g. from Sonnet to Opus for harder tasks
/clear                    # clear conversation history, keep files unchanged
/exit                     # exit Claude Code session
```

## Modes

**How:** press `Shift + Tab` to cycle through modes

| Mode | Status bar | Description | When to use |
|------|------------|-------------|-------------|
| **Accept edits** | `⏵⏵ accept edits on` | Claude automatically accepts all file changes | Default mode — Claude saves changes without asking |
| **Plan** | `⏸ plan mode on` | Claude reads code in read-only mode and returns a plan — no changes made | Before any complex or long task — always start here |
| **Auto** | `⏵⏵ auto mode on` | Claude works autonomously without asking for permission | You trust Claude with the task, want hands-off execution |
| **Manual** | `⏸ manual mode on` | Claude asks permission before every action | Sensitive code, unfamiliar codebase, want full control |

### Accept edits
![Accept edits mode](assets/mode-accept-edits.jpeg)

### Plan
![Plan mode](assets/mode-plan.jpeg)

### Auto
![Auto mode](assets/mode-auto.jpeg)

### Manual
![Manual mode](assets/mode-manual.jpeg)

> 💡 Best practice: start in **Plan** mode to review what Claude intends to do, then switch to **Auto** or **Manual** to execute
---

<div align="center" style="background-color: #1a1a2e; padding: 20px; border-radius: 10px; border: 2px solid #e67e22;">

# Steering Long Sessions

</div>

## Scope the work first with plan mode

### Plan Mode

**When:** before starting any long or complex task — always start here before executing anything
**How:** toggle on before giving Claude the task, then describe what you want done

**Steps:**
1. Navigate to your project folder
2. Start Claude Code: `claude`
3. Press `Shift + Tab` until you see `⏸ plan mode on` at the bottom
4. Type your task and press Enter
5. Claude reads your code in **read-only** mode and returns a plan
6. Review the plan — iterate if something is missing or wrong
7. When happy with the plan, press `Shift + Tab` to switch to Auto or Manual mode to execute
8. To exit Claude Code: `/exit` or `Ctrl + C`

```bash
Shift + Tab               # cycle modes until you see: ⏸ plan mode on
/exit                     # exit Claude Code and return to terminal
```

> ⚠️ Claude makes **no changes** in plan mode — safe to explore without risk
> 💡 Iterating on a plan is much faster than cleaning up a mess after Claude runs


---
## Steer while Claude works

### Compact

**What it does:** summarizes our conversation, replaces it with the summary as new context, and deletes the old messages — freeing up Claude's "working memory" so it can keep going on long tasks

**When to use:** when we are deep into a long session and Claude's context window is getting full

**The risk:** if the summary drops something important, Claude loses track and drifts off course

**The fix:** always add an instruction after `/compact` to tell Claude what to keep

**How to use:**

```bash
/compact                                          # ⚠️ risky — no instruction, Claude decides what to keep
/compact focus on the --version flag              # ✅ safe — Claude keeps this in the summary
```

**Real example:**

we are working on a CLI tool. We spent 30 minutes debugging a crash, fixed it, and now we are building a new `--version` flag. Our context window is almost full.

❌ Bad:

/compact

Claude might summarize the debugging session and forget we already fixed the crash — then try to fix it again.

✅ Good:

/compact the crash in src/cli.ts is already fixed, focus on the --version flag implementation

Claude summarizes everything but makes sure the summary keeps: crash = fixed, current task = --version flag.

> 💡 Think of `/compact` as "clear our desk but keep the notes that matter" — we decide which notes stay
---

### Rewind

**What it does:** takes us back to a previous checkpoint in your session — every user prompt automatically creates a checkpoint you can revert to

**When to use:** when Claude goes in the wrong direction and we want to undo without having to prompt your way back out

**How to use:** double tap `Escape` on an empty prompt to open the Rewind menu

```bash
Escape + Escape           # open Rewind menu (on empty prompt)
```

**Real example:**

We asked Claude to refactor a function. It went off track and started rewriting half the file. Instead of writing prompts to undo everything, we double tap Escape and roll back to before we gave that instruction.

**Rewind menu options:**

| Option | What it does | When to use |
|--------|-------------|-------------|
| Restore code and conversation | Rolls back both files and chat | Claude made wrong changes AND said wrong things |
| Restore conversation | Rolls back chat only, keeps file changes | You want to keep file changes but restart the conversation |
| Restore code | Rolls back files only, keeps chat | Claude changed wrong files but the conversation is still useful |
| Summarize from here | Summarizes everything after this checkpoint | You had a side conversation and want to free up context space |
| Summarize up to here | Summarizes everything before this checkpoint | You had a long setup phase you want to compress, but want to keep the recent implementation work intact |

> 💡 Think of each prompt we send as a save point in a video game — Rewind lets us load any of them
---

## Let Claude run more autonomously
Everything so far assumes you are hands-on, watching and correcting. Goal and Loop let Claude work with less supervision.

---

**What it does:** sets a completion condition — Claude keeps working across turns until a fast evaluator confirms the condition is met. It won't stop just because it thinks it's finished.

**When to use:** when we can describe what "done" looks like better than the steps to get there

**Important constraint:** the evaluator only reads the transcript — so our condition must be checkable from Claude's actual output (e.g. test results, type checker output)

**How to use:**

```bash
/goal all tests in src/billing pass and type checker reports zero errors
/goal clear               # cancel active goal
```

**Real example:**

We are fixing a bug in a billing module. Instead of checking every few minutes if the tests pass, we set a goal:

/goal all tests in src/billing pass and the type checker reports zero errors


Claude keeps working — running tests, fixing errors, running again — until both conditions are confirmed. Then it stops.

❌ Bad goal — not checkable from output:

/goal the code looks clean and well organised


✅ Good goal — checkable from output:

/goal all tests pass and there are zero TypeScript errors


> 💡 Think of Goal as "don't stop until this is actually done" — Claude won't give up after the first attempt

---

### Loop

**What it does:** runs a prompt on an interval between turns — either fixed or self-paced. Use it to pull something external and act when the state changes.

**When to use:** when we need Claude to watch something external repeatedly — like a CI run, a deploy, or an API response — and react when it changes

**How to use:**

```bash
/loop                     # start loop — Claude runs prompt on interval
Escape                    # stop loop
```

**Real example:**

We triggered a deployment and want Claude to check if it succeeded and then run follow-up tasks automatically:

/loop check if the deployment at staging.myapp.com is live, and when it is, run the smoke tests


Claude checks on an interval, waits for the deploy to go live, then runs the smoke tests — without you having to watch.

> 💡 Think of Loop as "keep checking until something changes, then act" — useful for anything that depends on an external trigger

---

## Run parallel work with worktrees

**What it does:** gives each Claude session its own independent file tree so multiple agents can work on the same codebase at the same time without conflicts

**When to use:** when we want to run multiple Claude agents in parallel on the same codebase

**The problem without worktrees:** two Claude sessions fighting over the same files leads to conflicts — like two people editing the same document at the same time

**How to use:**

```bash
/worktree                 # manage worktrees
```

When a session exits, its worktree is automatically cleaned up.

**Real example:**

We want Claude to work on two features at the same time — a new search feature and a bug fix in the billing module. Without worktrees, both sessions would edit the same files and cause conflicts.

With worktrees:
- Session 1 gets its own file tree → works on search feature
- Session 2 gets its own file tree → works on billing bug fix
- Neither can overwrite the other's changes
- When both finish, worktrees are automatically removed

**The `.worktreeinclude` file:**

Some files are git-ignored (like `.env`) but we still need them in every worktree. Add them to `.worktreeinclude` at repo root and they will be automatically copied into each new worktree.

```bash
# .worktreeinclude example
.env
config.local.json
```

> 💡 Think of worktrees as "separate desks for each agent" — everyone has their own workspace, no one gets in each other's way
---


## Putting it together

Handling long Claude Code sessions comes down to a handful of habits:

1. Scope your work first, then steer.
2. Direct your compaction so the summary keeps what matters.
3. Use the rewind menu to course correct when Claude drifts.
4. Set a goal when you can describe "done" better than you can describe the steps.
5. Run parallel work in worktrees.
   
Do that, and you can trust a long run without babysitting every step of it.



*Last updated: July 2026*
