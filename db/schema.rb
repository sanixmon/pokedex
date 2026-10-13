# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2026_10_13_000001) do
  create_table "pokemons", force: :cascade do |t|
    t.integer "pokedex_number", null: false
    t.string "name", null: false
    t.string "primary_type", null: false
    t.string "secondary_type"
    t.float "height"
    t.float "weight"
    t.string "abilities"
    t.integer "hp", default: 0
    t.integer "attack", default: 0
    t.integer "defense", default: 0
    t.integer "special_attack", default: 0
    t.integer "special_defense", default: 0
    t.integer "speed", default: 0
    t.integer "base_experience", default: 0
    t.string "sprite_url"
    t.string "artwork_url"
    t.text "description"
    t.integer "generation", default: 1
    t.boolean "is_legendary", default: false, null: false
    t.string "color"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_pokemons_on_name", unique: true
    t.index ["pokedex_number"], name: "index_pokemons_on_pokedex_number", unique: true
    t.index ["primary_type"], name: "index_pokemons_on_primary_type"
  end
end
