# 🚀 Roadmap Aplikasi Keuangan (Finance App)

Berikut adalah *step-by-step* rencana pengembangan dari fitur-fitur kompleks yang telah dilist. Saat ini, aplikasi baru memiliki **struktur folder standar** dan **UI dasar (Onboarding & Dashboard tĩnh)**. Seluruh fitur utama seperti database, transaksi, statistik, dan sinkronisasi **belum diimplementasikan**.

## Tahap 1: Setup Architecture & Local Database (Minggu 1)
Karena ini aplikasi keuangan yang butuh kecepatan dan dukungan *offline*, database lokal (SQLite/Isar) adalah pilihan utama.
- [ ] Menerapkan *State Management* yang solid (misal: Provider/Riverpod atau BLoC) di seluruh aplikasi.
- [ ] Mendesain struktur tabel database: `Accounts`, `Categories`, `Transactions`, `Budgets`.
- [ ] Membuat fungsi CRUD dasar untuk akun (Cash, Debit, Tabungan, dll.) dan kategori.
- [ ] Model data *Double-Entry Bookkeeping* sederhana (Kredit & Debit seimbang pada transfer antar akun).

## Tahap 2: Core Tracking & Input (Minggu 2)
Mengembangkan inti dari pencatatan keuangan.
- [ ] Form Input Pemasukan & Pengeluaran dengan pemilih tanggal, kategori, dan akun.
- [ ] Fitur Transfer antar akun (mengurangi saldo akun A, menambah akun B).
- [ ] Menyimpan Lampiran Foto/Struk ke *local storage* menggunakan `image_picker`.
- [ ] Membuat fitur *Bookmark / Template* transaksi rutin (misal: Beli Kopi, Bayar Listrik).
- [ ] *(Advance)* Logic *Recurring Transactions* menggunakan penjadwalan otomatis atau pengecekan *cron job* saat aplikasi dibuka.

## Tahap 3: Tampilan & Navigasi (Minggu 3)
Menyempurnakan UI untuk menampilkan data transaksi secara terstruktur.
- [ ] Mengaktifkan *Calendar View* dengan indikator titik di setiap hari yang ada transaksinya (`table_calendar`).
- [ ] *Summary Page*: Tampilan mingguan, bulanan, dan tahunan yang dinamis mengikuti aliran data.
- [ ] *Search & Filter*: Mencari catatan transaksi berdasarkan kata kunci, tanggal, batas harga, dan akun.
- [ ] Menyambungkan data dari *Local Database* dengan UI Dashboard yang sudah ada (menjadi dinamis).

## Tahap 4: Statistik & Laporan (Minggu 4)
Visualisasi agar pengguna dapat memantau *cash-flow* dengan mudah.
- [ ] Mengintegrasikan library *charts* (misal: `fl_chart` atau `syncfusion_flutter_charts`).
- [ ] *Pie chart* untuk visualisasi *Income vs Expense* berdasarkan kategori.
- [ ] *Line Chart* (Asset Graph) untuk melihat tren total aset (net worth) dari waktu ke waktu.
- [ ] Fitur Export Data Transaksi dari Local Database ke format Excel (`excel`) atau CSV (`csv`).

## Tahap 5: Fitur Budgeting (Minggu 5)
Sistem pembatasan pengeluaran agar pengguna lebih hemat.
- [ ] Model & UI untuk membuat *Budget Planning* per kategori (misal: Makan maksimal Rp1juta/bulan).
- [ ] Kalkulasi sisa budget dibandingkan dengan *actual spending* berjalan.
- [ ] Indikator visual progres bar (hijau aman, kuning mendekati limit, merah over-budget) di Dashboard.

## Tahap 6: Kustomisasi & Sekuritas (Minggu 6)
Fitur pendukung tambahan (*Nice-to-have* & Personalisasi).
- [ ] *Settings Page* untuk mengedit warna/ikon pada kategori agar lebih personal.
- [ ] Pengaturan *Multi-Currency* dan pergantian tanggal awal bulan keuangan (misal gajian tiap tanggal 25).
- [ ] *Dark Mode* dan *Light Mode* (tema adaptif di konfigurasi `MaterialApp`).
- [ ] *PIN Lock* (Screen Lock sederhana untuk masuk aplikasi) dengan package `local_auth` jika mendukung biometric/sidik jari.

## Tahap 7: Backup & Sinkronisasi (Tahap Lanjutan)
Menghindari data hilang jika device berganti atau rusak.
- [ ] Fitur eksport/import database (SQLite file) lokal untuk *Manual Backup*.
- [ ] *(Advance)* Menggunakan Local Wi-Fi Sync (membuat semacam mini-server di ponsel agar PC bisa menarik *database* langsung di jaringan Wi-Fi yang sama).

---

> Rencana ini akan menjadi panduan (agent instructions) untuk setiap *prompt* ke depan saat kita mengimplementasikan modul-modul ini satu-persatu.
