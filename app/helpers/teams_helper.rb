module TeamsHelper

  def team_image team, folder = "original"
    if team and team["short_code"]
      logical_path = 'teams/'+folder+'/'+team["short_code"]+'.png'
      if asset_available? logical_path
        image_tag(asset_path(logical_path), alt: team["name"]).html_safe
      else
        image_tag(asset_path('players/'+folder+'/default.jpg'), alt: team["name"]).html_safe   
      end
    end
  end

  def playing_cup team
    if team and team["playing_cup"]
      image_tag(asset_path('players/cup.png'), alt: "Ganador de la Copa del Rey").html_safe
    end
  end

  def team_url team
    team['object_link'].sub! ENV["BACK_URL"], ENV["FRONT_URL"]
  end
end