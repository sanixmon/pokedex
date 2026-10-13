# Pokédex — Ruby on Rails 8

Aplikasi Pokédex sederhana: daftar Pokémon, cari by nama/nomor, filter by tipe,
halaman detail + stats bar, CRUD manual, dan import dari [PokeAPI](https://pokeapi.co).

## Stack

- Ruby 3.2.3, Rails 8.1.4
- SQLite3 + Active Record
- Hotwire (Turbo/Stimulus), Importmap, Propshaft
- CSS custom (tanpa Tailwind), data awal dari PokeAPI

## Cara jalan

```bash
# install deps (butuh sudo untuk /var/lib/gems)
sudo bundle install

# siapkan DB + seed 24 Pokémon Gen 1
bundle exec rails db:prepare
bundle exec rails db:seed

# server
bundle exec rails server
# buka http://localhost:3000
```

## Fitur

- `GET /` — grid + search (`?q=pikachu` / `?q=25`), filter tipe (`?type=fire`),
  sort No./Nama/Total Stats, pagination 24/page
- `GET /pokemons/:id` — detail: artwork, deskripsi, tinggi/berat,
  abilities, base stats + bar, prev/next navigation
- CRUD penuh: Tambah / Edit / Hapus Pokémon manual
- `POST /pokemons/import_single?q=mew` — import satu Pokémon dari PokeAPI
- `rails pokemon:import[from=1,to=151]` — import range dari PokeAPI
- `rails pokemon:import_one[id=pikachu]` — import satu via rake

## Struktur

```
app/models/pokemon.rb            # validasi, scope search/by_type, total_stats
app/controllers/pokemons_controller.rb
app/services/poke_api_service.rb # Net::HTTP client ke pokeapi.co
app/views/pokemons/              # index, show, _form, new, edit
app/helpers/pokemons_helper.rb   # warna badge per tipe
app/assets/stylesheets/pokedex.css
db/migrate/*_create_pokemons.rb
db/seeds.rb                      # import API + fallback lokal
lib/tasks/pokemon.rake
```

## Contoh

```bash
# cari
curl "http://localhost:3000/pokemons?q=char"

# import Pokémon baru
bundle exec rails pokemon:import_one[id=lucario]
bundle exec rails pokemon:import[from=152,to=251]
```
