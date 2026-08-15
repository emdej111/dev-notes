# Verify Changes

## Description
After any code change, refactor, or bug fix in the Roofy backend (src/) is complete. Also use when explicitly asked to verify, check, or review recent changes.

## Procedure
1. Run `./check.sh` and capture the full output
2. Read the diff of every changed file with `git diff`
3. Confirm no existing test was weakened, skipped, or removed — see reference.md for what counts as weakened
4. Confirm new code paths (new routes, new branches) have a corresponding test
5. Report PASS or FAIL, with the evidence attached — see reference.md for the report format

If `check.sh` fails, stop and report the failure. Do not attempt to "fix" a failing test by loosening its assertions — fix the underlying code, or flag it back to the user.
