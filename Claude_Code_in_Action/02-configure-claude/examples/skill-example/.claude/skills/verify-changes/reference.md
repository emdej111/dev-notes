# Verification Reference

## What counts as a weakened test
- Removing or commenting out an assertion
- Changing a strict assertion into a loose one — e.g. `assert response.status_code == 200` becoming `assert response.status_code is not None`
- Adding a `try/except` around test code that swallows a failure instead of letting it fail
- Deleting a test case instead of fixing the code it exercises
- Changing test fixtures or mock data so a broken function happens to pass
- Reducing coverage thresholds in `pytest.ini` or `pyproject.toml` to get a green run

## What does NOT count as weakening
- Splitting one large test into several smaller, more specific tests
- Updating a test's expected value because the underlying business rule genuinely changed (this must be called out explicitly in the report)
- Adding new fixtures to reduce duplication

## Project-specific checks (Roofy backend)
- Auth routes: confirm there is a test asserting unauthenticated requests are rejected (per `.claude/conventions/testing.md`)
- Supabase calls: confirm external calls are mocked in unit tests, not hitting a real project
- New API routes: confirm they live under `src/api/handlers/`, one per file, per `.claude/conventions/code-style.md`

## What to include in the report
- Test suite: X passed, Y failed, Z errors
- Coverage: current % vs the 80% goal
- Files changed: list with line counts
- Test integrity: confirmed clean / issue found (describe exactly what and where)
- New code without a matching test: list, or "none"
- Overall: PASS / FAIL
