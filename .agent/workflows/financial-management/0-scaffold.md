---
description: "Step 0 — Inisialisasi Project Flutter & Struktur Folder"
---

# 🏗️ STEP 0 — Project Scaffold

Sebelum mulai, siapkan dependensi utama dan buat struktur folder yang rapi sesuai arsitektur Spendly.

## 0a. Menambahkan Dependensi
Tambahkan paket-paket berikut ke `pubspec.yaml` untuk mendukung navigasi, state management, grafik, dan ekspor PDF.

// turbo
- Jalankan: `flutter pub add provider google_fonts fl_chart lucide_icons intl path_provider pdf printing shared_preferences`

## 0b. Struktur Folder Project
Buat struktur folder berikut di dalam direktori `lib/` untuk memisahkan logika, UI, dan utilitas.

```
lib/
├── models/         # Data structures (Transaction, Category)
├── state/          # State management (AppState)
├── widgets/        # Reusable components (Buttons, Card, Chips)
│   ├── shared/
│   └── charts/
├── pages/          # Screens (Dashboard, Analytics, etc.)
│   ├── onboarding/
│   ├── dashboard/
│   └── transactions/
└── utils/          # Constants, formatters, helpers
    ├── theme.dart
    ├── currency.dart
    ├── date_helper.dart
    └── pdf_service.dart
```

// turbo
- Jalankan: `mkdir -p lib/models lib/state lib/widgets/shared lib/widgets/charts lib/pages/onboarding lib/pages/dashboard lib/pages/transactions lib/utils`
