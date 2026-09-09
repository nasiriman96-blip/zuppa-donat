# Zuppa & Donat — Kasir & Keuangan (satu project Supabase dengan Mataram Bakery)

Aplikasi kasir dengan login aman dan **4 dompet terpisah** — Modal & Untung untuk
masing-masing kategori (Zuppa, Donat).

Project ini dirancang untuk **memakai project Supabase yang SAMA dengan Mataram
Bakery** — jadi kamu login pakai akun yang sama, tapi data produk & transaksinya
tetap terpisah (tabelnya beda: `zd_products` & `zd_transactions`, bukan
`products` & `transactions` yang dipakai Mataram Bakery).

## Fitur utama
- Login pakai akun Supabase yang sama dengan Mataram Bakery (tidak perlu daftar ulang)
- **4 dompet**: Zuppa Modal, Zuppa Untung, Donat Modal, Donat Untung — setiap penjualan otomatis membagi Modal (HPP) dan Untung (profit) ke dompet sesuai kategori produknya
- Kategori produk: **Zuppa** dan **Donat** saja
- Hanya **admin** (role yang sama seperti di Mataram Bakery) yang bisa menghapus & mengedit riwayat transaksi
- Setiap transaksi menampilkan tanggal & jam lengkap
- Bisa tambah item manual di keranjang (untuk pesanan custom), dengan pilihan kategori Zuppa/Donat
- Laporan omset harian siap kirim ke WhatsApp

## Cara kerja 4 dompet
Saat checkout, tiap item di keranjang sudah punya kategori (Zuppa/Donat) dan harga modal.
- **Modal** dari HPP barang terjual otomatis masuk ke **Dompet Modal** kategori itu
- **Keuntungan** (harga jual − modal) otomatis masuk ke **Dompet Untung** kategori itu
- Kalau satu transaksi berisi campuran Zuppa + Donat, pembagiannya otomatis dihitung per item

---

## 1. Tambahkan tabel ke project Supabase Mataram Bakery yang sudah ada
1. Buka project Supabase **yang sama** dengan yang dipakai Mataram Bakery
2. Buka **SQL Editor** → **New query**
3. Tempel **seluruh isi** file `supabase/tambahan-untuk-project-mataram.sql`, klik **Run**
   (ini membuat tabel `zd_products` & `zd_transactions` yang terpisah dari tabel Mataram Bakery, plus 6 menu contoh: 3 Zuppa + 3 Donat)
4. Tidak perlu bikin ulang tabel `profiles` atau trigger — itu sudah ada dan dipakai bersama

## 2. Konfigurasi environment lokal
```bash
cp .env.example .env
```
Isi `.env` dengan **`Project URL` dan `anon public key` yang SAMA** seperti punya Mataram Bakery (lihat file `.env` project Mataram Bakery kamu, atau ambil lagi dari Supabase → Project Settings → API).

## 3. Jalankan aplikasi
```bash
npm install
npm run dev
```
Login pakai akun yang sama dengan yang kamu pakai di Mataram Bakery — kalau akun itu sudah admin di sana, otomatis admin juga di sini.

## 4. Unggah ke GitHub (repo BARU, terpisah dari Mataram Bakery)
```bash
git init
git add .
git commit -m "Zuppa & Donat: setup awal"
git branch -M main
git remote add origin https://github.com/USERNAME/NAMA-REPO-BARU.git
git push -u origin main
```
**Jangan** commit file `.env`.

## 5. Deploy (opsional)
Hubungkan repo GitHub **baru** ini ke project Vercel **baru** (terpisah dari project Vercel Mataram Bakery), lalu isi Environment Variables `VITE_SUPABASE_URL` dan `VITE_SUPABASE_ANON_KEY` — nilainya sama persis dengan punya Mataram Bakery.

---

## Kenapa kode & deploy tetap terpisah, tapi database gabungan?
- **Kode & Vercel terpisah**: karena ini aplikasi dengan tampilan & fitur beda (4 dompet vs 2 dompet), jadi tetap 2 repo & 2 link berbeda
- **Database (Supabase) gabungan**: karena kamu cuma perlu 1 akun untuk login ke kedua aplikasi, dan tidak perlu bayar/kelola 2 project Supabase terpisah

## Struktur folder
```
src/
  App.jsx              -> gerbang login
  MainApp.jsx           -> seluruh tampilan kasir/dompet/riwayat
  styles.js             -> semua CSS aplikasi
  lib/supabaseClient.js -> koneksi ke Supabase (project yang sama dengan Mataram Bakery)
  hooks/useAuth.js      -> status login & role user
  components/Login.jsx  -> form masuk & daftar
supabase/tambahan-untuk-project-mataram.sql -> SQL tambahan (jalankan di project Supabase Mataram Bakery)
```

## Catatan
- Kalau suatu saat kamu mau pisahkan lagi jadi project Supabase sendiri, tinggal bilang — saya bisa buatkan `schema.sql` versi lengkap & mandiri lagi.
- Saya (Claude) tidak bisa langsung login ke akun Supabase/GitHub kamu — langkah di atas perlu dijalankan sendiri. Kalau ada error, kirim pesan errornya, saya bantu perbaiki.
