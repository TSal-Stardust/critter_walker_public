# Critter Walker (working title)

Critter Walker (working title) is a creature-raising mobile game built with Flutter. You walk in the real world, your companion counts those steps, and a mysterious egg slowly grows into a fully discovered critter you can track through its forms in the compendium.

This repository is the public, code-safe version of the project. It exists so the app's engineering work can be shared openly without publishing the private production art, UI mockups, writing, or other unreleased creative materials used in the full game.

## What the App Does

- Tracks player movement using the device pedometer.
- Converts step progress into creature growth and hatching.
- Persists companion progress locally on device.
- Unlocks discovered forms in the Critter Compendium.
- Ships as a Flutter app with Android, iOS, desktop, and web project scaffolding.

At the current stage of development, the playable loop centers on a starter egg that hatches into Squidge and progresses through multiple forms as the player accumulates steps.

## Why This Repo Is Public

This repository is open so developers, collaborators, and curious players can:

- See how the game logic is structured.
- Follow the app's progress in public.
- Review, discuss, or contribute to the codebase.
- Learn from the Flutter implementation for step-based progression systems.

The full production project is not public. Final art, narrative content, design files, and other unreleased creative assets stay in the private development repository.

## Public Build Policy

The public repository is intentionally sanitized before publication.

- Production assets are not included here.
- Placeholder assets are substituted into the public build.
- The publishing pipeline replaces `assets/` with `public_assets/` before pushing to the public repository.
- This is designed to prevent unreleased art, UI deliverables, and writing from being exposed through the open repository.

That means this repo is the real application code, but not the full commercial content set.

## Tech Stack

- Flutter
- Dart
- `pedometer`
- `permission_handler`
- `shared_preferences`
- GitHub Actions for CI and public-repo publishing

## Getting Started

### Prerequisites

- Flutter SDK
- Dart SDK
- Android Studio, Xcode, or another supported Flutter toolchain

### Run Locally

```bash
flutter pub get
flutter run
```

### Test and Analyze

```bash
flutter analyze
flutter test
```

## Repository Layout

- `lib/` contains the application code.
- `assets/` contains the assets used by this repository build.
- `public_assets/` contains the placeholder/public-safe assets used by the publishing pipeline.
- `.github/workflows/` contains CI and public publishing automation.
- `test/` and `integration_test/` contain automated coverage for the app.

## Project Status

Critter Walker is in active development. The public repo currently reflects an early gameplay slice focused on:

- step tracking
- local persistence
- hatching and growth thresholds
- form discovery
- compendium presentation

Additional game systems, production presentation, and final content are being developed privately.

## Contributing

Issues and thoughtful pull requests are welcome for the public codebase. If you contribute, keep in mind that this repository is intentionally separated from the private production content pipeline, so changes should not depend on unreleased assets or private design materials.

## Licensing

The source code in this repository is licensed under the Apache License 2.0. See [LICENSE](LICENSE) for the full text.

Important boundaries:

- The Apache-2.0 license applies to the code and any repository content that is explicitly included in this public repository.
- Unreleased production art, private UI mockups, narrative writing, design documentation, audio, and other private project materials are not included here and are not licensed by this repository.
- Placeholder and public-safe assets included in this repository are only licensed to the extent they are actually present in this repo.

If a file or asset is not present in this repository, this repository does not grant rights to it.

## Notes for Reviewers

If you are evaluating the project for collaboration, contribution, or technical review, treat this repository as the public engineering surface of the game rather than a dump of the complete production build. The code is real, the app is real, and the private creative pipeline remains intentionally separate.
