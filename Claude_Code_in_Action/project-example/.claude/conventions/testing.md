# Testing Conventions

## General rules
- Every new feature must have tests before it is considered done
- Every bug fix must include a regression test
- Tests must pass before every commit — no exceptions
- Test names must clearly describe what they test

## Python (backend — pytest)
- Put tests in tests/ directory, mirroring the src/ structure
- One test file per module — e.g. src/api/handlers/listings.py → tests/api/handlers/test_listings.py
- Use fixtures for shared test data — not copy-pasted setup code
- Mock external services (Supabase, Stripe, email) in unit tests
- Integration tests may use a real test database — never production

## What to test
- Happy path — the expected use case works correctly
- Edge cases — empty inputs, boundary values, unexpected formats
- Error cases — what happens when something goes wrong
- Auth — protected routes reject unauthenticated requests

## What not to test
- Third-party library internals
- Simple getters and setters with no logic
- Framework behaviour (FastAPI, React Native handle their own)

## Commands
```bash
pytest                    # run all tests
pytest tests/api/         # run specific folder
pytest -k "test_listing"  # run tests matching name
pytest --cov              # run with coverage report
```

## Goal
```bash
/goal all tests pass and coverage is above 80%
```
