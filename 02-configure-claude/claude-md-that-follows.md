
# A CLAUDE.md That ActuallyFollows

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

---

### Phrasing is what makes rules stick

Once we decide a rule belongs in CLAUDE.md, whether Claude actually follows it comes down to how we phrase it. Most rules fail because they are vague — if we can't check whether a rule was followed, neither can Claude.

---

#### Be specific and checkable

Ask yourself: can I look at the result and immediately tell if this rule was followed?

❌ Vague — what does "best practices" even mean?

Follow best practices for API routes.

✅ Specific — we can immediately verify this:

Put new API routes in src/api/handlers, one per file.

The second one is explicit. We look at the folder, we see one file per route — done or not done. That's the bar every rule should clear.

---

#### Name the replacement — don't just ban something

When we tell Claude not to do something, always say what to do instead. Otherwise we have left the door open.

❌ Leaves it open — okay, but then what?
Don't use default exports.


✅ Closes it — no room for misinterpretation:

Use named exports, not default exports.


The second version names the replacement, so there is nothing left to guess.

---

#### Emphasis is a budget

Words like `IMPORTANT` and `YOU MUST` do raise a rule's priority — but only relative to everything quieter around them.

**The problem:** if every rule shouts, nothing stands out. The emphasis loses all meaning.

Think of it like this — if our CLAUDE.md looks like this:

IMPORTANT: Use named exports
YOU MUST: Put routes in src/api/handlers
IMPORTANT: Write tests for every feature
YOU MUST: Never use console.log in production
IMPORTANT: All comments in English


Claude sees five things shouting at equal volume. Nothing is actually prioritised.

✅ Better approach — save emphasis for what really hurts:

Use named exports, not default exports.
Put new API routes in src/api/handlers, one per file.
Write tests for every new feature.
All comments must be in English.

YOU MUST: Never log sensitive data like passwords or tokens.


Now only one rule shouts — and Claude knows that one actually matters.

> 💡 Treat emphasis like a budget. Spend it on the 2-3 rules that hurt most when broken. Let the rest sit at normal volume.

---

#### Keep the file under revision

CLAUDE.md is never finished — treat it like living code that keeps getting edited.

**When Claude does something wrong:**
- Don't just fix it by hand and move on
- Treat it as a bug report against your CLAUDE.md
- Ask yourself: "why didn't my rules prevent this?"
- Add or improve the rule that should have caught it

**Shortcut:** tell Claude directly:

Add that to the CLAUDE.md file

Claude will write the rule for us. That way the file gets better every time something goes wrong.

---

### Bottom line

Treat CLAUDE.md like production code. If we can't justify a line, delete it.

| Rule | Why it matters |
|------|----------------|
| Move hard rules to **hooks** | Real enforcement — Claude physically can't break them |
| Organize with **imports** | Keeps the file readable — but remember, context doesn't shrink |
| Make rules **specific and checkable** | If we can't verify it, Claude can't either |
| **Name the replacement** | Don't just ban — say what to do instead |
| Treat emphasis as a **budget** | Spend it on what hurts most |
| **Keep revising** | Every mistake Claude makes is a bug report |

> 💡 The whole idea is simple: the leaner the file, the more of it Claude follows.

---
