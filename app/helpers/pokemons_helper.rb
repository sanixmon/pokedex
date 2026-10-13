module PokemonsHelper
  TYPE_COLORS = {
    "normal" => "#A8A77A", "fire" => "#EE8130", "water" => "#6390F0",
    "electric" => "#F7D02C", "grass" => "#7AC74C", "ice" => "#96D9D6",
    "fighting" => "#C22E28", "poison" => "#A33EA1", "ground" => "#E2BF65",
    "flying" => "#A98FF3", "psychic" => "#F95587", "bug" => "#A6B91A",
    "rock" => "#B6A136", "ghost" => "#735797", "dragon" => "#6F35FC",
    "dark" => "#705746", "steel" => "#B7B7CE", "fairy" => "#D685AD",
    "stellar" => "#5A7DFF"
  }.freeze

  def type_color(type)
    TYPE_COLORS[type.to_s.downcase] || "#777"
  end

  def type_badge(type)
    return "" if type.blank?

    content_tag(:span, type.capitalize,
      class: "type-badge",
      style: "background-color: #{type_color(type)}")
  end

  def stat_bar_color(value)
    case value.to_i
    when 0..49 then "#f44336"
    when 50..89 then "#ff9800"
    else "#4caf50"
    end
  end
end
