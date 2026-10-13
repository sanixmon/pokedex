# Seeds Pokedex — idempotent, bisa dijalankan ulang.
# Coba import dari PokeAPI dulu (Gen 1). Kalau offline, pakai data lokal fallback.

puts "Seeding Pokedex..."

begin
  if Pokemon.count.zero?
    puts "Coba import 24 Pokemon dari PokeAPI..."
    ids = [ 1, 2, 3, 4, 5, 6, 7, 8, 9, 25, 26, 39, 65, 68, 94, 131, 133, 134, 135, 136, 143, 149, 150, 151 ]
    PokeApiService.import_range(ids)
  else
    puts "Database sudah berisi #{Pokemon.count} Pokemon, skip import API."
  end
rescue StandardError => e
  puts "Import API gagal (#{e.message}), pakai data lokal fallback..."
end

FALLBACK = [
  { n: 1,   name: "bulbasaur",  t1: "grass",    t2: "poison",   h: 0.7, w: 6.9,  ab: "overgrow, chlorophyll",      hp: 45,  at: 49,  df: 49,  sa: 65,  sd: 65,  sp: 45,  exp: 64,  desc: "Ada benih tumbuhan di punggungnya sejak lahir. Benih itu tumbuh membesar seiring tubuhnya." },
  { n: 2,   name: "ivysaur",    t1: "grass",    t2: "poison",   h: 1.0, w: 13.0, ab: "overgrow, chlorophyll",      hp: 60,  at: 62,  df: 63,  sa: 80,  sd: 80,  sp: 60,  exp: 142, desc: "Kuncup di punggungnya membesar dan mengeluarkan aroma manis saat mekar." },
  { n: 3,   name: "venusaur",   t1: "grass",    t2: "poison",   h: 2.0, w: 100.0, ab: "overgrow, chlorophyll",     hp: 80,  at: 82,  df: 83,  sa: 100, sd: 100, sp: 80,  exp: 263, desc: "Bunganya menyerap sinar matahari untuk energi. Aromanya menenangkan Pokémon lain." },
  { n: 4,   name: "charmander", t1: "fire",     t2: nil,        h: 0.6, w: 8.5,  ab: "blaze, solar-power",         hp: 39,  at: 52,  df: 43,  sa: 60,  sd: 50,  sp: 65,  exp: 62,  desc: "Api di ujung ekornya menunjukkan kondisi tubuhnya. Padam berarti sekarat." },
  { n: 5,   name: "charmeleon", t1: "fire",     t2: nil,        h: 1.1, w: 19.0, ab: "blaze, solar-power",         hp: 58,  at: 64,  df: 58,  sa: 80,  sd: 65,  sp: 80,  exp: 142, desc: "Bertarung dengan agresif dan menyemburkan api biru keputihan yang sangat panas." },
  { n: 6,   name: "charizard",  t1: "fire",     t2: "flying",   h: 1.7, w: 90.5, ab: "blaze, solar-power",         hp: 78,  at: 84,  df: 78,  sa: 109, sd: 85,  sp: 100, exp: 267, desc: "Api di sayapnya bisa melelehkan batu. Sering terbang mencari lawan yang kuat." },
  { n: 7,   name: "squirtle",   t1: "water",    t2: nil,        h: 0.5, w: 9.0,  ab: "torrent, rain-dish",         hp: 44,  at: 48,  df: 65,  sa: 50,  sd: 64,  sp: 43,  exp: 63,  desc: "Bersembunyi di tempurung lalu menyemprotkan air saat terancam." },
  { n: 8,   name: "wartortle",  t1: "water",    t2: nil,        h: 1.0, w: 22.5, ab: "torrent, rain-dish",         hp: 59,  at: 63,  df: 80,  sa: 65,  sd: 80,  sp: 58,  exp: 142, desc: "Ekornya yang berbulu menyimpan energi. Berenang lincah di air." },
  { n: 9,   name: "blastoise",  t1: "water",    t2: nil,        h: 1.6, w: 85.5, ab: "torrent, rain-dish",         hp: 79,  at: 83,  df: 100, sa: 85,  sd: 105, sp: 78,  exp: 265, desc: "Meriam air di tempurungnya menembakkan semburan yang bisa melubangi baja." },
  { n: 25,  name: "pikachu",    t1: "electric", t2: nil,        h: 0.4, w: 6.0,  ab: "static, lightning-rod",      hp: 35,  at: 55,  df: 40,  sa: 50,  sd: 50,  sp: 90,  exp: 112, desc: "Menyimpan listrik di pipinya. Melepaskan sengatan saat terkejut." },
  { n: 26,  name: "raichu",     t1: "electric", t2: nil,        h: 0.8, w: 30.0, ab: "static, lightning-rod",      hp: 60,  at: 90,  df: 55,  sa: 90,  sd: 80,  sp: 110, exp: 218, desc: "Ekornya menyalurkan listrik ke tanah agar tidak tersengat sendiri." },
  { n: 39,  name: "jigglypuff", t1: "normal",   t2: "fairy",    h: 0.5, w: 5.5,  ab: "cute-charm, competitive",    hp: 115, at: 45,  df: 20,  sa: 45,  sd: 25,  sp: 20,  exp: 95,  desc: "Nyanyiannya membuat pendengar tertidur. Matanya yang besar memikat lawan." },
  { n: 65,  name: "alakazam",   t1: "psychic",  t2: nil,        h: 1.5, w: 48.0, ab: "synchronize, inner-focus",   hp: 55,  at: 50,  df: 45,  sa: 135, sd: 95,  sp: 120, exp: 250, desc: "Otaknya luar biasa cerdas dengan IQ 5000. Kekuatan psikisnya sangat kuat." },
  { n: 68,  name: "machamp",    t1: "fighting", t2: nil,        h: 1.6, w: 130.0, ab: "guts, no-guard",            hp: 90,  at: 130, df: 80,  sa: 65,  sd: 85,  sp: 55,  exp: 253, desc: "Empat lengannya melancarkan pukulan beruntun yang tak terlihat mata." },
  { n: 94,  name: "gengar",     t1: "ghost",    t2: "poison",   h: 1.5, w: 40.5, ab: "cursed-body",                hp: 60,  at: 65,  df: 60,  sa: 130, sd: 75,  sp: 110, exp: 250, desc: "Bersembunyi di bayangan dan mencuri panas tubuh mangsanya." },
  { n: 131, name: "lapras",     t1: "water",    t2: "ice",      h: 2.5, w: 220.0, ab: "water-absorb, shell-armor", hp: 130, at: 85,  df: 80,  sa: 85,  sd: 95,  sp: 60,  exp: 187, desc: "Pokémon baik yang mengangkut manusia menyeberangi lautan dengan nyanyiannya." },
  { n: 133, name: "eevee",      t1: "normal",   t2: nil,        h: 0.3, w: 6.5,  ab: "run-away, adaptability",     hp: 55,  at: 55,  df: 50,  sa: 45,  sd: 65,  sp: 55,  exp: 65,  desc: "Struktur genetiknya tidak stabil sehingga bisa berevolusi ke banyak bentuk." },
  { n: 134, name: "vaporeon",   t1: "water",    t2: nil,        h: 1.0, w: 29.0, ab: "water-absorb, hydration",    hp: 130, at: 65,  df: 60,  sa: 110, sd: 95,  sp: 65,  exp: 184, desc: "Tubuhnya tersusun dari molekul air sehingga bisa menyatu dengan air." },
  { n: 135, name: "jolteon",    t1: "electric", t2: nil,        h: 0.8, w: 24.5, ab: "volt-absorb, quick-feet",    hp: 65,  at: 65,  df: 60,  sa: 110, sd: 95,  sp: 130, exp: 184, desc: "Mengumpulkan ion negatif dari udara untuk melepaskan petir 10.000 volt." },
  { n: 136, name: "flareon",    t1: "fire",     t2: nil,        h: 0.9, w: 25.0, ab: "flash-fire, guts",           hp: 65,  at: 130, df: 60,  sa: 95,  sd: 110, sp: 65,  exp: 184, desc: "Kantung apinya menyimpan udara panas 1650 derajat yang disemburkan saat bertarung." },
  { n: 143, name: "snorlax",    t1: "normal",   t2: nil,        h: 2.1, w: 460.0, ab: "immunity, thick-fat",       hp: 160, at: 110, df: 65,  sa: 65,  sd: 110, sp: 30,  exp: 189, desc: "Makan 400 kg makanan sehari lalu tidur. Didengkurannya tidak terganggu apapun." },
  { n: 149, name: "dragonite",  t1: "dragon",   t2: "flying",   h: 2.2, w: 210.0, ab: "inner-focus, multiscale",   hp: 91,  at: 134, df: 95,  sa: 100, sd: 100, sp: 80,  exp: 300, desc: "Pokémon baik hati yang terbang mengelilingi dunia untuk menyelamatkan yang tenggelam." },
  { n: 150, name: "mewtwo",     t1: "psychic",  t2: nil,        h: 2.0, w: 122.0, ab: "pressure, unnerve",         hp: 106, at: 110, df: 90,  sa: 154, sd: 90,  sp: 130, exp: 306, desc: "Hasil rekayasa genetik dari Mew. Kekuatan psikisnya terkuat di antara semua Pokémon.", leg: true },
  { n: 151, name: "mew",        t1: "psychic",  t2: nil,        h: 0.4, w: 4.0,  ab: "synchronize",                hp: 100, at: 100, df: 100, sa: 100, sd: 100, sp: 100, exp: 270, desc: "Pokémon langka yang konon memiliki gen semua Pokémon. Bisa mempelajari semua jurus.", leg: true }
].freeze

FALLBACK.each do |d|
  Pokemon.find_or_initialize_by(pokedex_number: d[:n]).tap do |p|
    p.assign_attributes(
      name: d[:name],
      primary_type: d[:t1],
      secondary_type: d[:t2],
      height: d[:h],
      weight: d[:w],
      abilities: d[:ab],
      hp: d[:hp],
      attack: d[:at],
      defense: d[:df],
      special_attack: d[:sa],
      special_defense: d[:sd],
      speed: d[:sp],
      base_experience: d[:exp],
      sprite_url: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/#{d[:n]}.png",
      artwork_url: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/#{d[:n]}.png",
      description: d[:desc],
      generation: 1,
      is_legendary: d[:leg] || false
    )
    p.save!
  end
end

puts "Seed selesai. Total Pokemon: #{Pokemon.count}"
