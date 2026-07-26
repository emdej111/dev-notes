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

> 💡 Best practice: start in **Plan** mode to review what Claude intends to do, then switch to **Auto** or **Manual** to execute
---

## Plan Mode

**When:** before starting any long or complex task
**How:** toggle on before giving Claude the task

```bash
Shift + Tab               # toggle plan mode on/off
```
> Claude reads code in read-only mode and returns a plan to review before doing anything

---

## Compact

**When:** context window is getting full during a long session
**How:** run in Claude Code prompt, always add an instruction

```bash
/compact                           # summarize conversation (risky — add instruction!)
/compact focus on the API changes  # summarize and keep specific context
```
> ⚠️ Never run `/compact` alone — direct what the summary should keep

---

## Rewind

**When:** Claude went in the wrong direction and you want to go back
**How:** double tap `Escape` on an empty prompt

```bash
Escape + Escape           # open Rewind menu
```

| Option | When to use |
|--------|-------------|
| Restore code and conversation | Roll back everything |
| Restore conversation | Roll back chat, keep file changes |
| Restore code | Roll back files, keep chat |
| Summarize from here | Free up space after a side conversation |
| Summarize up to here | Compress a long setup phase, keep recent work |

---

## Goal

**When:** you can describe what "done" looks like better than the steps to get there
**How:** run in Claude Code prompt — condition must be checkable from Claude's output

```bash
/goal all tests in src/billing pass and type checker reports zero errors
/goal clear               # cancel active goal
```

---

## Loop

**When:** you need Claude to check something external repeatedly (CI run, deploy status)
**How:** run in Claude Code prompt, Claude runs on an interval until you stop it

```bash
/loop                     # start loop — Claude runs prompt on interval
Escape                    # stop loop
```

---

## Worktrees

**When:** running multiple Claude agents on the same codebase in parallel
**How:** each agent gets its own independent file tree — no conflicts

```bash
/worktree                 # manage worktrees
```
> Add `.worktreeinclude` at repo root to copy git-ignored files (e.g. `.env`) into each worktree

---

*Last updated: July 2026*
