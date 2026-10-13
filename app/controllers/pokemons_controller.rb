class PokemonsController < ApplicationController
  before_action :set_pokemon, only: %i[show edit update destroy]

  PER_PAGE = 24

  def index
    @query = params[:q].to_s.strip
    @type_filter = params[:type].to_s.strip.downcase
    @type_filter = "" unless Pokemon::TYPES.include?(@type_filter)
    @sort = params[:sort].to_s
    @page = [ params[:page].to_i, 1 ].max

    scope = Pokemon.search(@query).by_type(@type_filter)
    scope = case @sort
            when "name" then scope.order(:name)
            when "total" then scope.to_a.sort_by { |p| -p.total_stats }
            else scope.ordered
            end

    if scope.is_a?(Array)
      @total_count = scope.size
      @pokemons = scope.slice((@page - 1) * PER_PAGE, PER_PAGE) || []
      @total_pages = (@total_count.to_f / PER_PAGE).ceil
    else
      @total_count = scope.count
      @total_pages = (@total_count.to_f / PER_PAGE).ceil
      @pokemons = scope.offset((@page - 1) * PER_PAGE).limit(PER_PAGE)
    end

    @all_types = Pokemon::TYPES
  end

  def show
  end

  def new
    @pokemon = Pokemon.new
  end

  def create
    @pokemon = Pokemon.new(pokemon_params)
    if @pokemon.save
      redirect_to @pokemon, notice: "#{@pokemon.display_name} berhasil ditambahkan!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @pokemon.update(pokemon_params)
      redirect_to @pokemon, notice: "#{@pokemon.display_name} berhasil diupdate!"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    name = @pokemon.display_name
    @pokemon.destroy
    redirect_to pokemons_path, notice: "#{name} berhasil dihapus."
  end

  # POST /pokemons/import_single?q=pikachu
  def import_single
    query = params[:q].to_s.strip.downcase
    if query.blank?
      redirect_to pokemons_path, alert: "Isi nama atau nomor Pokemon dulu."
      return
    end

    attrs = PokeApiService.fetch_pokemon_attributes(query)
    record = Pokemon.find_or_initialize_by(pokedex_number: attrs[:pokedex_number])
    record.assign_attributes(attrs)
    record.save!
    redirect_to record, notice: "#{record.display_name} berhasil diimport dari PokeAPI!"
  rescue StandardError => e
    redirect_to pokemons_path, alert: "Gagal import: #{e.message}"
  end

  private

  def set_pokemon
    @pokemon = Pokemon.find(params[:id])
  end

  def pokemon_params
    params.require(:pokemon).permit(
      :pokedex_number, :name, :primary_type, :secondary_type,
      :height, :weight, :abilities, :hp, :attack, :defense,
      :special_attack, :special_defense, :speed, :base_experience,
      :sprite_url, :artwork_url, :description, :generation,
      :is_legendary, :color
    )
  end
end
