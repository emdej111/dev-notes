# Code Style Conventions

## General
- Use named exports, not default exports
- All comments must be in English
- Keep functions small and focused — one responsibility per function
- Prefer explicit over implicit — avoid magic numbers and unclear abbreviations

## Python (backend)
- Follow PEP 8 style guide
- Use type hints on all function signatures
- Use f-strings for string formatting, not .format() or %
- Put new API routes in src/api/handlers, one per file
- Use async/await for all database and HTTP calls

## TypeScript (frontend)
- Use TypeScript strict mode
- Prefer interfaces over types for object shapes
- Use const over let wherever possible
- No any types — always define proper types

## Naming
- Variables and functions: camelCase
- Classes and components: PascalCase
- Constants: UPPER_SNAKE_CASE
- Database tables and columns: snake_case
- Files: kebab-case
