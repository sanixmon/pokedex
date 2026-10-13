require "net/http"
require "json"
require "uri"

# Service object untuk ambil data dari PokeAPI (https://pokeapi.co).
# Tanpa gem tambahan, murni Net::HTTP stdlib.
class PokeApiService
  BASE_URL = "https://pokeapi.co/api/v2".freeze

  class ApiError < StandardError; end

  def self.import_range(range, verbose: true)
    range.each do |id|
      attrs = fetch_pokemon_attributes(id)
      record = Pokemon.find_or_initialize_by(pokedex_number: attrs[:pokedex_number])
      record.assign_attributes(attrs)
      record.save!
      puts "  ✓ #{record.display_number} #{record.display_name}" if verbose
    rescue StandardError => e
      puts "  ✗ ##{id}: #{e.message}"
    end
  end

  def self.fetch_pokemon_attributes(id_or_name)
    data = get("/pokemon/#{id_or_name.to_s.downcase}")
    species = get("/pokemon-species/#{data["id"]}") rescue {}

    types = (data["types"] || []).sort_by { |t| t["slot"] }.map { |t| t["type"]["name"] }
    stats = {}
    (data["stats"] || []).each { |s| stats[s["stat"]["name"]] = s["base_stat"] }

    flavor = (species["flavor_text_entries"] || [])
      .select { |e| e.dig("language", "name") == "en" }
      .map { |e| e["flavor_text"].gsub(/[\n\f\r]/, " ").squeeze(" ") }
      .uniq.first || ""

    {
      pokedex_number: data["id"],
      name: data["name"],
      primary_type: types[0] || "normal",
      secondary_type: types[1],
      height: data["height"].to_f / 10,   # dm -> m
      weight: data["weight"].to_f / 10,   # hg -> kg
      abilities: (data["abilities"] || []).map { |a| a["ability"]["name"].tr("-", " ") }.join(", "),
      hp: stats["hp"] || 0,
      attack: stats["attack"] || 0,
      defense: stats["defense"] || 0,
      special_attack: stats["special-attack"] || 0,
      special_defense: stats["special-defense"] || 0,
      speed: stats["speed"] || 0,
      base_experience: data["base_experience"] || 0,
      sprite_url: data.dig("sprites", "front_default"),
      artwork_url: data.dig("sprites", "other", "official-artwork", "front_default") ||
                   data.dig("sprites", "front_default"),
      description: flavor,
      generation: generation_from_species(species),
      is_legendary: species["is_legendary"] || false,
      color: species.dig("color", "name")
    }
  end

  def self.generation_from_species(species)
    url = species.dig("generation", "url").to_s
    roman = url.split("/").reject(&:empty?).last.to_s.gsub("generation-", "").upcase
    roman_map = { "I" => 1, "II" => 2, "III" => 3, "IV" => 4, "V" => 5,
                  "VI" => 6, "VII" => 7, "VIII" => 8, "IX" => 9 }
    roman_map[roman] || 1
  end

  def self.get(path)
    uri = URI("#{BASE_URL}#{path}")
    response = Net::HTTP.start(uri.host, uri.port, use_ssl: true,
                               open_timeout: 10, read_timeout: 15) do |http|
      http.get(uri.request_uri, "User-Agent" => "RailsPokedex/1.0")
    end
    raise ApiError, "HTTP #{response.code} untuk #{path}" unless response.is_a?(Net::HTTPSuccess)

    JSON.parse(response.body)
  end
end
