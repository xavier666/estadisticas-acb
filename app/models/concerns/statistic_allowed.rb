module StatisticAllowed
  extend ActiveSupport::Concern

  module ClassMethods
    def active
      joins(:player).where("players.active = true")
    end
    def bases
      joins(:player).where("players.position = 'base'")
    end
    def aleros
      joins(:player).where("players.position = 'alero'")
    end
    def pivots
      joins(:player).where("players.position = 'pivot'")
    end
  end
end