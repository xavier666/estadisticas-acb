class Statistic

  FIELDS = %w( game min pt t2 t3 t1 reb a br bp c tap m fp fr mas_menos v sm )  
  FIELDS_DEFAULT = ["-", "0'", "0", "0/0", "0/0", "0/0", "0(0+0)", "0", "0", "0", "0", "0+0", "0", "0", "0", "0", "0", "0.00" ]  

  NUM_GAMES = ENV["NUM_ROUNDS"]

  def self.num_games
    NUM_GAMES.to_i
  end

  def self.fields
    FIELDS
  end

end