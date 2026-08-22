# Project Rules

This project is a Croatian apartment rental platform (Roofy).
Backend: FastAPI + Python | Frontend: React Native + Expo | Database: PostgreSQL + Supabase

## Conventions

@.claude/conventions/code-style.md
@.claude/conventions/testing.md
@.claude/conventions/workflow.md

## Hard rules — enforced via hooks, not here

The following rules are too critical to leave as guidance.
They are enforced by hooks that physically block the action:
- Never push directly to main branch
- Never log sensitive data (passwords, tokens, OTPs)
- Never commit .env files

## Notes

- All comments and documentation must be in English
- When in doubt, ask before making large structural changes
- Prefer small, focused commits over large sweeping changes
