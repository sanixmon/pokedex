Rails.application.routes.draw do
  root "pokemons#index"

  resources :pokemons do
    collection do
      post :import_single
    end
  end

  get "up" => "rails/health#show", as: :rails_health_check
end
