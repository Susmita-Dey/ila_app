# Changelog

All notable changes to the **Ila Health** project will be documented in this file.

## [1.2.0] - 2026-08-17

### Clinical & Phenotype Engine
- **Compassionate Insight Reframing:** Removed rigid, anxiety-inducing alerts (e.g., "YES / FLAGGED") from the Doctor PDF. Reframed Rotterdam diagnostics and symptom clustering to use objective, phenotype-centric terminology (`Observed Pattern`, `Luteal Alignment`, `Distributed Pattern`).

### UI & UX
- **Retroactive Routine Logging:** Implemented a native time picker (`showTimePicker`) within the "Catch Up" drawer. Users can now accurately log the exact hour and minute they took a missed medication on a past day, rather than defaulting to the current timestamp.

## [1.1.0] - 2026-08-16

### Security
- **Hardened Local Backups:** Replaced the legacy single-iteration hash with a cryptographically secure **PBKDF2** key derivation function (`pointycastle` 100,000 iterations). Added unique salt prepending to prevent dictionary/brute-force attacks on exported `.ila` backups.

### Stability & Performance
- **Report Generation Optimization:** Offloaded heavy clinical mathematics and adherence aggregation to a background Isolate (`compute`) during PDF generation, preventing UI frame drops when parsing large multi-year date ranges.
- **Memory Leak Resolution:** Extracted `AlertDialog` into a dedicated stateful widget (`BackupPassphraseDialog`) to properly dispose `TextEditingController`s, resolving a memory leak in the Settings screen.
- **Onboarding Polish:** Fixed a dangling `PageController` reference in `OnboardingScreen` ensuring it's successfully destroyed after navigation.

### Bug Fixes
- **Flaky Testing Framework:** Eliminated cross-test timer bleeding ("Timer pending after widget tree disposal") by integrating formal Riverpod `ProviderContainer` scoping and explicit Drift database tear-downs.

### UI & UX
- **Language Localization Preparations:** Completed structural preparations for ARB/l10n files. Adopted the "Insights" and "Sanctuary" language mappings across core UI elements.
- **Offline Reliability:** Verified the underlying PDF generation logic to operate entirely isolated from network modules, ensuring robust offline-first functionality for intermittent internet areas.

## [1.0.0] - Launch Release

Welcome to the first official release of **Ila Health**! Built with a relentless focus on absolute privacy, venture-backed utility aesthetics, and clinical accuracy, Ila is designed to be the ultimate safe haven for women's health tracking.

### Added
- **Zero-Cloud Architecture**: Complete offline implementation using `drift` SQLite.
- **Biometric Security Gate (`local_auth`)**: App enforces FaceID / TouchID / Fingerprint unlocking automatically upon startup and when resuming from the background.
- **AES-256 Encrypted Backups**: Introduced a `BackupService` using the `encrypt` package to serialize all clinical data into a single AES-encrypted `ila_data.ila_backup` payload, exported completely offline via `share_plus`.
- **Dynamic PCOS Cycle Graph**: Added a visual dashboard anchor (`CycleGraph`) to render cycle timelines with strict 45-day PCOS anomaly guardrails and distinct `Ila Rose` warning badges.
- **Clinical Math & PMDD Clustering**: DSM-5 compliant phase analysis and PDF generation via isolates.
- **Dynamic Routine Engine**: 21/7 cyclic tracking and daily adherence math, with automated local push reminders scheduled natively via `flutter_local_notifications`.
- **App Switcher Privacy Mask**: Obscures the UI in the iOS/Android app switcher to prevent accidental data leakage via background screenshots.
- **Buttery Micro-Animations**: Injected Apple Design Award-level micro-transitions throughout the UI (`TodayScreen`, `QuickLogSheet`, `CycleGraph`) and a beautiful 3-screen animated Onboarding Flow using `flutter_animate`.
- **SQLite Query Indexing (`@TableIndex`)**: Drift database tables are explicitly indexed on date columns to guarantee sub-100ms queries across a 10-year data lifespan.
- **Total Data Erasure**: One-tap permanent database dropping and memory cache invalidation.
