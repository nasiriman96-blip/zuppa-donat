-- ============================================================
-- Skema TAMBAHAN untuk Zuppa & Donat
-- Jalankan ini di project Supabase yang SAMA dengan Mataram Bakery
-- (tabel profiles, trigger user baru, dan login SUDAH ada, jadi
-- tidak dibuat ulang di sini — cukup login yang sama dipakai bersama).
-- ============================================================

-- Tabel produk khusus Zuppa & Donat (terpisah dari tabel produk Mataram Bakery)
create table if not exists public.zd_products (
  id bigint generated always as identity primary key,
  name text not null,
  category text not null,
  kind text not null,
  cost numeric not null default 0,
  price numeric not null default 0,
  created_by uuid references auth.users(id),
  created_at timestamptz not null default now()
);

alter table public.zd_products enable row level security;

drop policy if exists "zd_products_select_all" on public.zd_products;
create policy "zd_products_select_all"
on public.zd_products for select
to authenticated
using (true);

drop policy if exists "zd_products_insert_all" on public.zd_products;
create policy "zd_products_insert_all"
on public.zd_products for insert
to authenticated
with check (true);

drop policy if exists "zd_products_update_all" on public.zd_products;
create policy "zd_products_update_all"
on public.zd_products for update
to authenticated
using (true)
with check (true);

drop policy if exists "zd_products_delete_all" on public.zd_products;
create policy "zd_products_delete_all"
on public.zd_products for delete
to authenticated
using (true);

-- Data awal (menu default) — hanya berjalan kalau tabel produk masih kosong
insert into public.zd_products (name, category, kind, cost, price)
select * from (values
  ('Zuppa Soup Reguler', 'zuppa', 'pastry', 6000, 12000),
  ('Zuppa Soup Jumbo', 'zuppa', 'pastry', 9000, 18000),
  ('Zuppa Ayam', 'zuppa', 'pastry', 7000, 14000),
  ('Donat Coklat', 'donat', 'pastry', 3000, 6000),
  ('Donat Kentang', 'donat', 'pastry', 3500, 7000),
  ('Donat Meses', 'donat', 'pastry', 3000, 6000)
) as seed(name, category, kind, cost, price)
where not exists (select 1 from public.zd_products);


-- Tabel riwayat transaksi khusus Zuppa & Donat (terpisah dari transaksi Mataram Bakery)
create table if not exists public.zd_transactions (
  id bigint generated always as identity primary key,
  type text not null,
  date timestamptz not null default now(),
  total numeric,
  hpp numeric,
  profit numeric,
  items jsonb,
  amount numeric,
  note text,
  wallet text,
  category text,
  "from" text,
  "to" text,
  created_by uuid references auth.users(id),
  created_at timestamptz not null default now()
);

alter table public.zd_transactions enable row level security;

drop policy if exists "zd_transactions_select_all" on public.zd_transactions;
create policy "zd_transactions_select_all"
on public.zd_transactions for select
to authenticated
using (true);

drop policy if exists "zd_transactions_insert_all" on public.zd_transactions;
create policy "zd_transactions_insert_all"
on public.zd_transactions for insert
to authenticated
with check (true);

-- HANYA admin yang boleh menghapus riwayat
drop policy if exists "zd_transactions_delete_admin_only" on public.zd_transactions;
create policy "zd_transactions_delete_admin_only"
on public.zd_transactions for delete
to authenticated
using (
  exists (
    select 1 from public.profiles
    where profiles.id = auth.uid() and profiles.role = 'admin'
  )
);

-- HANYA admin yang boleh mengubah/edit riwayat
drop policy if exists "zd_transactions_update_admin_only" on public.zd_transactions;
create policy "zd_transactions_update_admin_only"
on public.zd_transactions for update
to authenticated
using (
  exists (
    select 1 from public.profiles
    where profiles.id = auth.uid() and profiles.role = 'admin'
  )
)
with check (
  exists (
    select 1 from public.profiles
    where profiles.id = auth.uid() and profiles.role = 'admin'
  )
);

-- ============================================================
-- Selesai! Karena tabel profiles & auth sudah ada dari Mataram
-- Bakery, akun yang sudah kamu daftarkan di sana (termasuk yang
-- sudah dijadikan admin) otomatis bisa dipakai login di Zuppa &
-- Donat juga — tidak perlu daftar ulang.
-- ============================================================
