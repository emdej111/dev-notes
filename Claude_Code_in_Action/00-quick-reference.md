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
![Accept edits mode](assets/mscreenshots/ode-accept-edits.jpeg)

### Plan
![Plan mode](assets/screenshots/mode-plan.jpeg)

### Auto
![Auto mode](assets/screenshots/mode-auto.jpeg)

### Manual
![Manual mode](assets/screenshots/mode-manual.jpeg)

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


*Last updated: August 2026*
