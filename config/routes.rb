Rails.application.routes.draw do

  resources :teams
  resources :players do
    collection do 
      get :brokerbasket
      get :historico
      get :temporada
      get :mejores_jornada
      get :comparar
      get :search
    end
  end
  resources :games
  resources :contents

  get 'players/comparar/:player_1_id' => 'players#comparar'
  get 'players/comparar/:player_1_id/:player_2_id' => 'players#comparar'
  get 'games/:round_id/round' => 'games#round', as: :games_round

  root "home#index"

end
