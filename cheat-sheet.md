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
### Goal

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


<div align="center" style="background-color: #1a1a2e; padding: 20px; border-radius: 10px; border: 2px solid #e67e22;">

# A CLAUDE.md That ActuallyFollows

</div>
---

## CLAUDE.md — A File Claude Actually Follows

**What it is:** a text file we place in the root of our project. Claude Code automatically reads it every time we start it in that folder — like an onboarding document for a new employee: "this is how we do things here."

**What it does:** tells Claude how our project is organised, what conventions to follow, and what it should and shouldn't do — without us having to explain it every single session.

**Example CLAUDE.md for a rental platform project:**
```markdown
# Project Rules

- This is a Croatian apartment rental platform
- Backend is FastAPI + Python, frontend is React Native + Expo
- Put new API routes in src/api/handlers, one per file
- Use named exports, not default exports
- All comments must be in English
```

**Key insight:** CLAUDE.md is not enforced configuration — it's guidance. Every line competes with every other line for Claude's attention. The longer the file, the more it competes with itself, and the less reliably Claude follows any single rule.

> 💡 The leaner the file, the more of it Claude actually follows. The goal isn't to write down everything — it's to keep the file tight.

---

### CLAUDE.md vs Hooks — know the difference

Before writing a rule, ask: is this guidance or a hard line that must never be crossed? Those are two different jobs.

**Example:** "Never push to main" sounds like a CLAUDE.md rule. But if we u put it there, we're hoping Claude reads it and respects it — most of the time it will. "Most of the time" isn't good enough for something that dangerous. That belongs in a hook instead.

A **hook** is code that runs before Claude takes an action and can actually block it. So even if Claude tries to push to main, the hook stops it. That's real enforcement, not a polite request.

| | CLAUDE.md | Hooks |
|---|---|---|
| **Type** | Guidance | Enforcement |
| **How it works** | Claude reads and tries to follow | Code that runs before Claude acts |
| **Can block actions?** | No — Claude can ignore it | Yes — physically stops the action |
| **Use for** | Conventions, style, preferences | Hard rules that must never be broken |

**Rule of thumb:**
- "Use named exports" → CLAUDE.md ✅ — soft convention, fine as guidance
- "Never push to main" → Hook ✅ — too dangerous to leave as a polite request

---

### The four locations

CLAUDE.md isn't just one file — there are four places it can live, and Claude loads all of them together at launch. They stack — nothing gets dropped.

| Location | Who controls it | Shared with team? | When to use |
|----------|----------------|-------------------|-------------|
| **Managed policy** | Platform/org team | Always active | Org-wide rules you can't exclude — always in play |
| **User** | You | No — follows you everywhere | Personal preferences that apply across all your projects on this machine |
| **Project** | Team | Yes — checked into repo | Shared conventions your whole team follows |
| **Local** | You | No — git ignored | Personal notes for this one repo only — won't affect teammates |

**Managed policy** — our organisation's rules. We can't turn it off. If our company says "never log passwords," that's here.

**User** — our personal style. If we always want Claude to write comments in English, we put it here once and it applies to every project on our machine automatically.

**Project** — the team file. Checked into git so everyone gets it. If our team agreed "all API routes go in src/api/handlers" — this is where that lives.

**Local** — our private scratchpad for one repo. Git ignores it completely so it never gets pushed or shared.

**When is Local useful?**

Imagine we are working on our own branch, refactoring a big feature. We want Claude to remember:
- "We decided to split this service into two separate modules"
- "Don't touch the payment logic — it's being rewritten separately"

We don't want these notes in the Project file — they would confuse our teammates who are not on our branch. We don't want them in User — they only apply to this one repo.

Local is the answer. It's just ours, just for this repo, and disappears from Claude's view the moment someone else opens the same project on their machine.

> 💡 Think of Local as a sticky note on your own desk — no one else sees it, and it doesn't end up in the shared office manual

---

### Split big files with imports

As our project grows, our CLAUDE.md can get very long. Instead of one giant wall of text, we can split it into multiple smaller files and reference them from the main CLAUDE.md using the `@` import syntax:

**Main CLAUDE.md:**
```markdown
# Project Rules

@.claude/conventions/code-style.md
@.claude/conventions/testing.md
@.claude/conventions/workflow.md
```

**Each imported file contains its own section:**
```markdown
# code-style.md
- Use named exports, not default exports
- Put new API routes in src/api/handlers, one per file
```

```markdown
# testing.md
- All new features must have tests
- Run tests before every commit
```

This way our main CLAUDE.md stays short and readable — instead of scrolling through 200 lines,we have a clean list of references.

**The important thing to understand — imports do NOT reduce context**

When Claude launches, it reads the main CLAUDE.md and immediately expands every `@` import inline — like copy-pasting the content of each file right where we referenced it.

Think of it like this:

❌ What we might think happens:

Claude reads CLAUDE.md → sees @testing.md → loads it only when needed



✅ What actually happens:

Claude reads CLAUDE.md → immediately opens testing.md → pastes everything inline → reads it all at once



So the total amount of text Claude reads is exactly the same — whether we have one big file or ten small ones. Splitting into imports does not make Claude faster or reduce its memory load.

**When to use imports:**

✅ We use imports to **organise** — makes the file easier for humans to read and maintain

❌ Don't use imports to **shrink the load** — Claude reads everything regardless

> 💡 Imports are for our benefit, not Claude's — they help us maintain the file, but Claude sees the same amount of text either way
