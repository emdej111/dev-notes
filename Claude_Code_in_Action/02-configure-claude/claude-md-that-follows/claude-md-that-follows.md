# A CLAUDE.md That Actually Follows

> How to write a CLAUDE.md file that Claude actually obeys — and when not to use it at all.

---

## The trap everyone falls into

Your CLAUDE.md file keeps growing. You hit a problem, you add a rule. You hit another, you add another. Before long you have one giant file, and Claude starts ignoring parts of it. That is not a bug in Claude — it is how the file works.

**Key insight:** CLAUDE.md is not enforced configuration — it is guidance. Every line competes with every other line for Claude's attention. The longer the file, the more it competes with itself, and the less reliably Claude follows any single rule.

> 💡 The leaner the file, the more of it Claude actually follows. The goal is not to write down everything — it is to keep the file tight.

---

## Step 1 — Ask if CLAUDE.md is even the right tool

Before you write a rule, ask whether it belongs in CLAUDE.md at all. Some rules are guidance, and some are hard lines that must never be crossed. Those are two different jobs.

**Example:** "Never push to main" sounds like a CLAUDE.md rule. But if you put it there, you are hoping Claude reads it and respects it — most of the time it will. "Most of the time" is not good enough for something that dangerous. That belongs in a hook instead.

A **hook** is code that runs before Claude takes an action and can actually block it. So even if Claude tries to push to main, the hook stops it. That is real enforcement, not a polite request.

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

## Step 2 — Know the four locations

CLAUDE.md is not just one file. There are four places it can live, and Claude loads all of them together at launch. They stack — nothing gets dropped.

| Location | Who controls it | Shared with team? | When to use |
|----------|----------------|-------------------|-------------|
| **Managed policy** | Platform/org team | Always active | Org-wide rules you can't exclude |
| **User** | You | No — follows you everywhere | Personal preferences across all projects on this machine |
| **Project** | Team | Yes — checked into repo | Shared conventions your whole team follows |
| **Local** | You | No — git ignored | Personal notes for this one repo only |

**When is Local useful?**

You are refactoring on your own branch and want Claude to remember some architectural decisions while you work. That does not belong in the shared Project file — it would affect your whole team. It goes in Local, where it is just yours for this repo.

> 💡 Think of Local as a sticky note on your own desk — no one else sees it, and it does not end up in the shared office manual

---

## Step 3 — Split big files with imports

When your project CLAUDE.md gets long, break it into pieces using the `@` import syntax:

```markdown
# Project Rules

@.claude/conventions/code-style.md
@.claude/conventions/testing.md
@.claude/conventions/workflow.md
```

Instead of one wall of text, you point to other files. Claude expands them inline when it launches.

> ⚠️ Imports help you **organise** — they do NOT reduce context. Claude still loads everything upfront. Use imports to organise, not to shrink the load.

**See a real example:** [examples/claude-md-example/](examples/claude-md-example/) — or the full cumulative project at [../../project-example/](../../project-example/)

---

## Step 4 — Phrase rules so they stick

Once you decide a rule belongs in CLAUDE.md, whether Claude actually follows it comes down to how you phrase it. Most rules fail because they are vague.

### Be specific and checkable

If you can't check whether a rule was followed, neither can Claude.

❌ Vague:
```
Follow best practices for API routes.
```

✅ Specific:
```
Put new API routes in src/api/handlers, one per file.
```

### Name the replacement — don't just ban something

❌ Leaves it open:
```
Don't use default exports.
```

✅ Closes it:
```
Use named exports, not default exports.
```

### Emphasis is a budget

Words like `IMPORTANT` and `YOU MUST` raise a rule's priority — but only relative to everything quieter around them. If every rule shouts, nothing stands out.

❌ Every rule shouting:
```
IMPORTANT: Use named exports
YOU MUST: Put routes in src/api/handlers
IMPORTANT: Write tests for every feature
YOU MUST: Never use console.log in production
```

✅ Emphasis saved for what really matters:
```
Use named exports, not default exports.
Put new API routes in src/api/handlers, one per file.
Write tests for every new feature.

YOU MUST: Never log sensitive data like passwords or tokens.
```

> 💡 Treat emphasis like a budget — spend it on the 2-3 rules that hurt most when broken

---

## Step 5 — Keep the file under revision

CLAUDE.md is never finished — treat it like living code.

- When Claude does something wrong → treat it as a bug report against your CLAUDE.md
- Tell Claude directly: *"add that to the CLAUDE.md file"* — it will write the rule for you
- If you can't justify a line → delete it

---

## Bottom line

| Rule | Why it matters |
|------|----------------|
| Move hard rules to **hooks** | Real enforcement — Claude physically can't break them |
| Organize with **imports** | Keeps the file readable — context doesn't shrink |
| Make rules **specific and checkable** | If you can't verify it, Claude can't either |
| **Name the replacement** | Don't just ban — say what to do instead |
| Treat emphasis as a **budget** | Spend it on what hurts most |
| **Keep revising** | Every mistake is a bug report |

> 💡 The whole idea is simple: the leaner the file, the more of it Claude follows.

---

*Last updated: August 2026*
