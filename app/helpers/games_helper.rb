module GamesHelper

  def game_url game
    game['object_link'].sub! BACK_URL, FRONT_URL
  end
  
end