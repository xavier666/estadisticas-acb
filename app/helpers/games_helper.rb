module GamesHelper

  def game_url game
    game['object_link'].sub! ENV["BACK_URL"], ENV["FRONT_URL"]
  end
  
end