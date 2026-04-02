---
description: Build a production-grade Personal Finance Management app with Flutter — includes onboarding, dashboard, transaction management, calendar, statistics, and a full AI Financial Analyst powered by Claude API. Dark luxury editorial aesthetic. Mobile-first.
---

# 💰 Spendly Finance OS — Flutter Build Workflow

Workflow ini telah dipecah menjadi beberapa bagian untuk kemudahan navigasi dan implementasi. Ikuti langkah-langkah di bawah ini secara berurutan untuk membangun aplikasi Spendly dari nol.

## 🚀 Daftar Isi Workflow

### [STEP 0 — Project Scaffold](file:///.agent/workflows/financial-management/0-scaffold.md)
Inisialisasi project Flutter, penambahan dependensi (Provider, fl_chart, dll), dan pengaturan struktur folder.

### [STEP 1 — Design System & Tools](file:///.agent/workflows/financial-management/1-theme-utils.md)
Pembuatan tema "Luxury Dark", sistem tipografi (Gold & Black), serta utilitas format mata uang IDR dan tanggal.

### [STEP 2 — Models & State Management](file:///.agent/workflows/financial-management/2-models-state.md)
Definisi model data transaksi dan pengelolaan state aplikasi secara global menggunakan Provider.

### [STEP 3 — Reusable UI Widgets](file:///.agent/workflows/financial-management/3-widgets.md)
Pembuatan komponen UI dasar seperti CurrencyDisplay, CategoryChip, dan BottomNav yang elegan.

### [STEP 4 — Data Visualization](file:///.agent/workflows/financial-management/4-charts.md)
Implementasi grafik bar mingguan dan donut chart kategori menggunakan paket `fl_chart`.

### [STEP 5 — Main Screens (Part 1)](file:///.agent/workflows/financial-management/5-dashboard-onboarding.md)
Pembuatan halaman Onboarding yang edukatif dan Dashboard interaktif.

### [STEP 6 — Transactions & Stats (Part 2)](file:///.agent/workflows/financial-management/6-transactions-stats.md)
Implementasi fitur pencatatan transaksi masuk/keluar dan halaman analisis statistik.

### [STEP 7 — AI Analyst & Final Build](file:///.agent/workflows/financial-management/7-ai-profile.md)
Integrasi fitur saran keuangan berbasis AI, halaman profil, dan perakitan akhir aplikasi di `main.dart`.

---
*Gunakan workflow ini untuk membangun aplikasi finansial premium yang responsif dan berfungsi penuh.*
