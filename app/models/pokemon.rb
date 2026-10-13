class Pokemon < ApplicationRecord
  TYPES = %w[
    normal fire water electric grass ice
    fighting poison ground flying psychic
    bug rock ghost dragon dark steel fairy stellar
  ].freeze

  validates :pokedex_number, presence: true, uniqueness: true,
            numericality: { only_integer: true, greater_than: 0 }
  validates :name, presence: true, uniqueness: { case_sensitive: false }
  validates :primary_type, presence: true, inclusion: { in: TYPES }
  validates :secondary_type, inclusion: { in: TYPES }, allow_blank: true
  validates :hp, :attack, :defense, :special_attack, :special_defense, :speed,
            numericality: { only_integer: true, greater_than_or_equal_to: 0 }, allow_nil: true

  before_validation :normalize_name

  scope :ordered, -> { order(:pokedex_number) }
  scope :search, ->(q) {
    next all if q.blank?

    term = "%#{q.to_s.strip.downcase}%"
    if q.to_s.strip.match?(/\A\d+\z/)
      where("pokedex_number = ? OR LOWER(name) LIKE ?", q.to_i, term)
    else
      where("LOWER(name) LIKE ?", term)
    end
  }
  scope :by_type, ->(type) {
    next all if type.blank?

    where("primary_type = ? OR secondary_type = ?", type, type)
  }
  scope :legendary, -> { where(is_legendary: true) }

  def types
    [ primary_type, secondary_type ].reject(&:blank?)
  end

  def total_stats
    [ hp, attack, defense, special_attack, special_defense, speed ].compact.sum
  end

  def display_number
    format("#%04d", pokedex_number)
  end

  def display_name
    name.to_s.capitalize
  end

  def abilities_list
    abilities.to_s.split(",").map(&:strip).reject(&:empty?)
  end

  def prev_pokemon
    self.class.where("pokedex_number < ?", pokedex_number).ordered.last
  end

  def next_pokemon
    self.class.where("pokedex_number > ?", pokedex_number).ordered.first
  end

  def stat_list
    {
      "HP" => hp,
      "Attack" => attack,
      "Defense" => defense,
      "Sp. Atk" => special_attack,
      "Sp. Def" => special_defense,
      "Speed" => speed
    }
  end

  private

  def normalize_name
    self.name = name.to_s.strip.downcase
  end
end
