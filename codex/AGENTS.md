# Working Agreements

## Formatting and linting

- Do not run standalone formatters or linters during ordinary code implementation.
  Repository pre-commit hooks own formatting and linting, so focus on the requested
  behavior and let a normal commit invoke those checks.
- Preserve and include changes made by pre-commit hooks. Run formatting or linting
  separately only when the user explicitly requests it or when diagnosing a hook
  failure.
