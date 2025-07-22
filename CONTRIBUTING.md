# Contributing to NPM Permissions Fix

Thank you for considering contributing to this project! This project uses [Semantic Release](https://github.com/semantic-release/semantic-release) to automate version management and package publishing. As such, we follow the [Conventional Commits](https://www.conventionalcommits.org/) specification.

## Commit Message Format

Each commit message consists of a **header**, a **body**, and a **footer**. The header has a special format that includes a **type**, an optional **scope**, and a **subject**:

```
<type>(<scope>): <subject>
<BLANK LINE>
<body>
<BLANK LINE>
<footer>
```

### Types

The commit type must be one of the following:

- **feat**: A new feature
- **fix**: A bug fix
- **docs**: Documentation only changes
- **style**: Changes that do not affect the meaning of the code (white-space, formatting, etc)
- **refactor**: A code change that neither fixes a bug nor adds a feature
- **perf**: A code change that improves performance
- **test**: Adding missing tests or correcting existing tests
- **build**: Changes that affect the build system or external dependencies
- **ci**: Changes to our CI configuration files and scripts
- **chore**: Other changes that don't modify src or test files
- **revert**: Reverts a previous commit

### Scope

The scope is optional and should be the name of the module affected (as perceived by the person reading the changelog).

### Subject

The subject contains a succinct description of the change:

- Use the imperative, present tense: "change" not "changed" nor "changes"
- Don't capitalize the first letter
- No dot (.) at the end

### Body

The body should include the motivation for the change and contrast this with previous behavior.

### Footer

The footer should contain any information about **Breaking Changes** and is also the place to reference GitHub issues that this commit **Closes**.

## Examples

```
feat(script): add support for FreeBSD operating system

Added detection and permission fixing for FreeBSD systems in the script.

Closes #123
```

```
fix(permissions): correct path for npm global packages

The script was using an incorrect path for global packages on some Linux distributions.
This commit fixes the path by using the correct npm prefix command.

Closes #456
```

```
docs: update README with better examples

Expanded the README.md file with more detailed examples and clearer instructions.
```

## Breaking Changes

If your commit includes a breaking change, the footer should start with `BREAKING CHANGE:` followed by a space or two newlines. The rest of the commit message is then used for explaining the breaking change.

```
feat(api): change how permissions are fixed

BREAKING CHANGE: The script now requires sudo access upfront instead of asking during execution.
This means that scripts that relied on the previous behavior will need to be updated.
```

## Pull Requests

When opening a pull request, please ensure:

1. Your commits follow the conventional commits format
2. You've added tests for your changes (if applicable)
3. You've updated documentation (if applicable)
4. Your branch is up to date with the latest master branch

Thank you for contributing!
