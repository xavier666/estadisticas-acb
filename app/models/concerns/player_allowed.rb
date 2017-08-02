module PlayerAllowed
  extend ActiveSupport::Concern

  module ClassMethods
    def active
      where(active: true)
    end
    def bases
      where(position: "base")
    end
    def aleros
      where(position: "alero")
    end
    def pivots
      where(position: "pivot")
    end

    # TOP
    def top_round
      where("players.best_round_val = ? 
        OR players.best_round_points = ? 
        OR players.best_round_rebounds = ? 
        OR players.best_round_assists = ? 
        OR players.best_round_3points = ?", 
        true, true, true, true, true)  
    end
  end
end