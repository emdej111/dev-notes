# Workflow Conventions

## Branching
- Never push directly to main — always work on a feature branch
- Branch naming: feature/short-description, fix/short-description, chore/short-description
- e.g. feature/map-search, fix/auth-token-expiry, chore/update-dependencies

## Commits
- Write commit messages in English
- Use imperative mood — "Add search filter" not "Added search filter"
- Keep commits small and focused — one logical change per commit
- Format: type: short description
  - feat: add map-based search
  - fix: resolve auth token expiry bug
  - chore: update dependencies
  - docs: update README with setup instructions
  - refactor: extract listing card into separate component

## Pull Requests
- Every PR must have a description explaining what changed and why
- Link to the relevant issue or ticket if applicable
- At least one review required before merging
- All tests must pass before merging
- No console.log or debug code in PRs

## Code Review
- Review for correctness, not style — style is handled by linter
- If something is unclear, ask — don't assume
- Approve only when you would be comfortable owning the code yourself

## Environment
- Never commit .env files — use .env.example with placeholder values
- Never use production credentials in local development
- Document any new environment variables in .env.example immediately

## Claude Code specific
- Always start in Plan mode before making large changes
- Use /compact when sessions get long — always add an instruction
- Hard rules (never push to main, never log tokens) are enforced via hooks — not here
