#!/bin/bash
set -o pipefail

echo "=== Running test suite (with coverage) ==="
pytest --cov --cov-report=term-missing

echo "=== Type check ==="
mypy src/

echo "=== Lint ==="
ruff check src/

echo "=== Done ==="
