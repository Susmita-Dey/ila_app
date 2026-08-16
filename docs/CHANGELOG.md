# Changelog

All notable changes to the **Ila Health** project will be documented in this file.

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
