# Contributing

## Setup

```bash
git clone https://github.com/ettysekhon/platform-auth.git
cd platform-auth
make setup
```

## Workflow

```bash
git checkout -b feature/your-feature-name

make lint
make template
make pre-commit

git commit -m "feat: add new realm configuration"
git push origin feature/your-feature-name
```

## PR Requirements

- Passing CI (lint, security, chart-test)
- CODEOWNERS approval
- No secrets or sensitive data

## Helm Guidelines

**Values**: Use `existingSecret` pattern for credentials, provide sensible defaults.

**Templates**: Use `_helpers.tpl` for naming, include resource limits and health probes.
