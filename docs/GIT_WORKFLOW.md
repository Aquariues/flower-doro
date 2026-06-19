# Git Workflow

Flower-doro uses a simple develop-to-main release flow.

## Branches

- `main`: release branch. Every push to `main` creates a GitHub release.
- `develop`: integration branch for completed work before release.
- `feature/*`: new product work.
- `fix/*`: bug fixes.
- `chore/*`: tooling, CI, docs, and maintenance.

## Normal Flow

1. Branch from `develop`.
2. Use one of these prefixes:
   - `feature/<short-name>`
   - `fix/<short-name>`
   - `chore/<short-name>`
3. Open a pull request into `develop`.
4. After `develop` is ready to release, open a pull request from `develop` into `main`.
5. Merge into `main` to create a release automatically.

## Release Behavior

The release workflow runs on every push to `main`.

Each release:

- builds the Swift package
- builds the macOS app product
- runs tests
- creates a tag like `v2026.06.19.12`
- publishes a GitHub release with generated notes
- attaches a zip artifact containing the macOS executable and resource bundle

## Local Commands

```sh
swift build
swift build --product FlowerDoroMac
swift test
```
