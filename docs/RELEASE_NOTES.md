# Release Notes

## Version 1.0.0 (Launch Release)

Welcome to the first official release of **Ila Health**! 
Built with a relentless focus on absolute privacy, venture-backed utility aesthetics, and clinical accuracy, Ila is designed to be the ultimate safe haven for women's health tracking.

### 🌟 Core Features

- **Zero-Cloud Architecture:** 
  - Your data never leaves your device. We use a strictly local, type-safe SQLite database (`drift`). 
  - There are no analytics trackers, no advertising IDs, and no hidden telemetry.
- **Clinical Math & PMDD Clustering:** 
  - The reporting engine groups your symptoms into clinical phases (Menstrual, Mid-Cycle, Luteal) based on DSM-5 diagnostic criteria.
  - Generates a PDF Doctor's Report entirely locally on your device using background isolates (`compute`) to ensure lightning-fast performance even with years of data.
- **Dynamic Routine Engine:**
  - Create completely custom routines (Daily, 21/7 Cycle, or specific days of the week).
  - Perfect for logging medication, mindfulness routines, or cyclic contraception.
- **Premium Utility Aesthetics:**
  - "Ila Rose" brand action color paired with "Absolute Onyx" and "Linen White".
  - High-contrast, sharp geometric typography tailored for maximum readability and a premium feel.

### 🔒 Privacy & Security Hardening

- **App Switcher Privacy Mask:** 
  - Switching apps instantly obscures the Ila UI with a blank canvas and the Ila Logo. 
  - OS-level background screenshots can never accidentally capture your clinical data or cycle status.
- **Total Data Erasure:** 
  - A single "Erase All Data" button permanently drops all database tables and flushes the memory cache instantly. 

### ⚙️ Technical Highlights

- Fully covered by a 21-test QA suite (Unit, Database Integrity, State Disposal, and E2E Integration).
- Daylight Saving Time (DST) timezone shifts gracefully handled via UTC normalization, ensuring cycle length calculations never drop a day.
- Mobile First: Compiled explicitly for iOS and Android platforms.
