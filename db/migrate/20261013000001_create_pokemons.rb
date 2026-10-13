class CreatePokemons < ActiveRecord::Migration[8.1]
  def change
    create_table :pokemons do |t|
      t.integer :pokedex_number, null: false
      t.string :name, null: false
      t.string :primary_type, null: false
      t.string :secondary_type
      t.float :height
      t.float :weight
      t.string :abilities
      t.integer :hp, default: 0
      t.integer :attack, default: 0
      t.integer :defense, default: 0
      t.integer :special_attack, default: 0
      t.integer :special_defense, default: 0
      t.integer :speed, default: 0
      t.integer :base_experience, default: 0
      t.string :sprite_url
      t.string :artwork_url
      t.text :description
      t.integer :generation, default: 1
      t.boolean :is_legendary, default: false, null: false
      t.string :color

      t.timestamps
    end

    add_index :pokemons, :pokedex_number, unique: true
    add_index :pokemons, :name, unique: true
    add_index :pokemons, :primary_type
  end
end
