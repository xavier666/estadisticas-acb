module PlayersHelper

  def player_image player, folder = "original"
    if player and player['image']
      logical_path = 'players/'+folder+'/'+player['image']
      if asset_available? logical_path
        image_tag(asset_path(logical_path), alt: player['full_name']).html_safe
      else
        image_tag(asset_path('players/'+folder+'/default.jpg'), alt: player['full_name']).html_safe
      end
    else 
      image_tag(asset_path('players/'+folder+'/default.jpg'), alt: player['full_name']).html_safe
    end
  end

  def player_price price
    number_with_delimiter(price, delimiter: ".")
  end

  def player_url player
    player['object_link'].sub! ENV["BACK_URL"], ENV["FRONT_URL"]
  end

  def current_price player
    player['price'][ENV["CURRENT_ROUND"]].to_i
  end

end