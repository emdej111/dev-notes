# Claude Code
## ANTHROPIC lessons

# Steering Long Sessions

Two core habits:
1. **Scope the work** before Claude starts
2. **Steer it** while it runs

### 1. Scope the work first with plan mode

- Before Claude writes a single line, get it to lay out a plan
- In plan mode, Claude works in **read-only** — reads code, figures out what needs to change, hands you a plan
- Actually read the plan — the more thorough the plan, the fewer surprises
- Iterate on the plan before Claude starts executing

```bash
Shift + Tab               # toggle plan mode on/off
```

### 2. Steer while Claude works

#### Compact

- Summarizes conversation, uses summary as new context, deletes old messages
- Frees up context window so Claude can keep going
- ⚠️ **Never run `/compact` on its own** — something important might get dropped

```bash
/compact                          # summarize conversation
/compact [instruction]            # summarize with focus
# e.g. /compact focus on the --version flag implementation
```

#### Rewind

- Takes you back to your last checkpoint
- Every user prompt creates a checkpoint you can revert to
- Open menu: **double tap Escape on an empty prompt**

| Option | Description |
|--------|-------------|
| Restore code and conversation | Roll back both together |
| Restore conversation | Roll back chat only |
| Restore code | Roll back files only |
| Summarize from here | Summarize everything after checkpoint — great for side conversations |
| Summarize up to here | Summarize everything before checkpoint — great for compressing long setup phases |

---

## Autonomous Mode

### Let Claude run more autonomously

#### Goal

- Sets a completion condition — Claude keeps working until a fast evaluator confirms conditions are met
- ⚠️ Condition must be checkable from Claude's actual output (e.g. test results)

```bash
/goal [description]               # set completion condition
# e.g. /goal all tests in src/billing pass and type checker reports zero errors
/goal clear                       # cancel active goal
```

#### Loop

- Runs a prompt on an interval between turns
- Use to pull something external (CI run, deploy) and act when state changes

```bash
/loop                             # start loop
Escape                            # stop loop
```

---

## Parallel Work — Worktrees

- When running multiple agents on the same codebase, each gets its own **independent file tree**
- Agents can't overwrite each other's changes
- Clean worktrees are automatically removed when a session exits

```bash
/worktree                         # manage worktrees
```

> Add a `.worktreeinclude` file at repo root to list git-ignored files (e.g. `.env`) to copy into each worktree

---

## Key Takeaways

- Scope first, then steer
- Direct your compaction so the summary keeps what matters
- Use Rewind to course-correct when Claude drifts
- Set a Goal when you can describe "done" better than the steps
- Run parallel work in worktrees

---

*Last updated: July 2026*
