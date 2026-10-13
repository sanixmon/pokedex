namespace :pokemon do
  desc "Import Pokemon dari PokeAPI, contoh: rails pokemon:import[from=1,to=151]"
  task import: :environment do
    from = (ENV["from"] || 1).to_i
    to = (ENV["to"] || 151).to_i
    puts "Import ##{from}..##{to} dari PokeAPI..."
    PokeApiService.import_range(from..to)
    puts "Selesai. Total: #{Pokemon.count}"
  end

  desc "Import satu Pokemon: rails pokemon:import_one[id=pikachu]"
  task import_one: :environment do
    id = ENV["id"] || ENV["name"] || "pikachu"
    attrs = PokeApiService.fetch_pokemon_attributes(id)
    record = Pokemon.find_or_initialize_by(pokedex_number: attrs[:pokedex_number])
    record.assign_attributes(attrs)
    record.save!
    puts "✓ #{record.display_number} #{record.display_name}"
  end
end
