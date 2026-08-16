# Changelog

All notable changes to the **Ila Health** project will be documented in this file.

## [3.0.0] - Ultra-Premium V3 Horizon
### Added
- **Biometric Security Gate (`local_auth`)**: App now enforces FaceID / TouchID / Fingerprint unlocking automatically upon startup and when resuming from the background. Includes gracefully failing open to device PIN if biometrics fail.
- **SQLite Query Indexing (`@TableIndex`)**: Drift database tables `CycleEvents` and `RoutineLogs` are now explicitly indexed on date columns to guarantee sub-100ms queries across a 10-year data lifespan.
- **Animated Onboarding Flow**: Replaced static welcome screen with a beautiful 3-screen PageView using `flutter_animate` micro-interactions, persistently storing the onboarding state via `shared_preferences`.

## [2.0.0] - Premium Tier & Local Encrypted Backups
### Added
- **AES-256 Encrypted Backups**: Introduced a `BackupService` using the `encrypt` package to serialize all clinical data into a single AES-encrypted `ila_data.ila_backup` payload, exported completely offline via `share_plus`.
- **Dynamic PCOS Cycle Graph**: Added a visual dashboard anchor (`CycleGraph`) to render cycle timelines with strict 45-day PCOS anomaly guardrails and distinct `Ila Rose` warning badges.
- **Buttery Micro-Animations**: Injected Apple Design Award-level micro-transitions throughout the UI (`TodayScreen`, `QuickLogSheet`, `CycleGraph`) using `flutter_animate`.
- **Local Push Notifications**: Automated local push reminders scheduled natively via `flutter_local_notifications` for the Routine Engine, with timezone math handled via `timezone`.

## [1.0.0] - Launch Release
### Added
- **Zero-Cloud Architecture**: Complete offline implementation using `drift` SQLite.
- **Clinical Math & PMDD Clustering**: DSM-5 compliant phase analysis and PDF generation via isolates.
- **Dynamic Routine Engine**: 21/7 cyclic tracking and daily adherence math.
- **App Switcher Privacy Mask**: Obscures the UI in the iOS/Android app switcher to prevent accidental data leakage via background screenshots.
- **Total Data Erasure**: One-tap permanent database dropping and memory cache invalidation.
