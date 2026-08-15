# Verification Skills

> How to build a skill that automatically verifies Claude's work — so you never have to remember to ask.

---

## Why this is the skill to build first

As a project grows, the same work keeps happening over and over — and skills are the natural way to automate that repetition. Out of everything worth turning into a skill, **verifying your own work** is the one to build first.

The reason is simple: verification is the check you're most likely to skip, and the one that costs the most when you do.

---

## The problem with manual verification

When Claude finishes a task, you have to remember to check the work. Ask it to run tests. Read the diff yourself. The problem: **the checking depends on you remembering to ask**. Skip that step once and bad code slips through.

A verification skill removes that dependency — it fires automatically when the work matches its description, and walks the same steps every time.

---

## What a verification skill does

You ask Claude to refactor something. When it finishes, the skill fires on its own and:

1. Runs the test suite
2. Reads the diff
3. Checks that no test was weakened just to make things pass
4. Reports pass or fail, with the evidence attached

The whole flow runs without you asking.

> ⚠️ **The critical check:** it's not enough to run tests and see green. A test can be quietly loosened so it passes no matter what. The skill reads the diff and confirms tests weren't weakened. **"Done" means gates were run and observed, with results stated explicitly.**

---

## The shape of a verification skill

A skill is a folder with a `skill.md` inside it:

```
.claude/skills/verify-changes/
├── skill.md       # name, description (trigger), procedure
├── reference.md   # detailed material — only loaded when needed
└── check.sh       # executable script — Claude runs it, doesn't load it
```

**See a real example:** [examples/skill-example/](examples/skill-example/) — or the full cumulative project at [../project-example/](../project-example/)

**`skill.md`** — keep this lean:

```markdown
# Verify Changes

## Description
After any code change, refactor, or bug fix is complete.

## Procedure
1. Run `./check.sh` and capture the output
2. Read the diff of all changed files
3. Confirm no existing test was weakened or removed
4. Report: PASS or FAIL, with evidence attached
```

**`check.sh`** — the actual tooling:

```bash
#!/bin/bash
echo "=== Running test suite ==="
python -m pytest --tb=short

echo "=== Type check ==="
mypy src/

echo "=== Lint ==="
ruff check src/
```

**`reference.md`** — detailed material Claude reads only when it needs depth:

```markdown
# Verification Reference

## What counts as a weakened test
- Removing assertions
- Changing assert X == Y to assert X is not None
- Adding try/except that swallows failures
- Commenting out test cases
- Changing test data to make a broken function pass

## What to include in the report
- Test suite: X passed, Y failed, Z errors
- Files changed: list with line counts
- Test integrity: confirmed / issue found (describe it)
- Overall: PASS / FAIL
```

---

## Which instruction surface owns which rule

You now have three places to put instructions, and it's easy to mix them up. Here's how to keep them straight.

**CLAUDE.md** holds conventions that apply all the time, regardless of what task is at hand — naming rules, where files go, how commits are written. This is the "always true" layer.

**Skills** hold procedures and reference material tied to a *specific kind of task* — verification, a release checklist, a migration recipe. A skill only becomes relevant when that kind of task comes up, which is exactly why its description is what triggers it.

**Hooks** are the odd one out, and the distinction matters: CLAUDE.md and skills are both *instructions that Claude follows* — Claude can, in principle, misread them, forget them, or decide they don't apply. A hook is *code that actually runs*, outside of Claude's judgment entirely. If a rule must never be skippable, it doesn't belong in CLAUDE.md or in a skill — it belongs in a hook.

| Surface | What belongs here | Can Claude skip it? |
|---------|------------------|---------------------|
| **CLAUDE.md** | Conventions that apply all the time — naming rules, where files go | Yes — it's guidance |
| **Skills** | Procedures tied to a specific kind of task — verification, releases, migrations | Yes — it's guidance |
| **Hooks** | Rules Claude must never be able to skip | No — it's code that actually runs |

> 💡 If skipping the rule is not acceptable, don't leave it up to instruction-following. Put it in a hook.

---

## Why keep `skill.md` lean

Only the **descriptions** of skills load into context at launch — not the full content. The full `skill.md` loads only when a skill is triggered.

This means:
- You can have many skills with zero context cost
- Heavy material (long explanations, scripts) goes in side files
- `skill.md` describes **what to do** — side files hold the depth and the tools

```
skill.md        → lean — describes the procedure
reference.md    → heavy — detailed material, loaded on demand
check.sh        → executable — Claude runs it, never loads it into context
```

---

## The rule of thumb

> If you've typed the same multi-step instruction twice, that's a skill.

This same shape carries any procedure your team repeats:
- A release checklist
- A migration recipe
- A pre-PR check
- A security scan before deploy

---

## How to set it up

1. Create the skill folder in your project:

```bash
mkdir -p .claude/skills/verify-changes
```

2. Create `skill.md`, `reference.md`, and `check.sh`

3. Make the script executable:

```bash
chmod +x .claude/skills/verify-changes/check.sh
```

4. Check it into your repo — now the whole team inherits the same verification move automatically:

```bash
git add .claude/skills/
git commit -m "Add verification skill"
```

> 💡 Once checked in, everyone's work gets checked the same way, automatically, without anyone having to remember to ask.

---

## Bottom line

| Concept | Key point |
|---------|-----------|
| **Why build this first** | Removes the dependency on you remembering to check |
| **The critical check** | Confirm tests weren't weakened — green isn't enough |
| **Keep `skill.md` lean** | Push heavy material and scripts into side files |
| **Description is the trigger** | The description field is what fires the skill automatically |
| **Skills vs hooks** | Skills are guidance; hooks are enforcement — don't confuse them |

---

*Last updated: August 2026*
