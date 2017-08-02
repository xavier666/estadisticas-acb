class Player
# Getting Data
  def total_stat field
    statistics.by_season([CURRENT_SEASON]).total[field].to_f
  end

  def played_games
    statistics.by_season([CURRENT_SEASON]).played_games.to_i
  end

  def promedio_minutos
    statistics.by_season([CURRENT_SEASON]).promedio["min"].to_s.chop.to_f
  end

  def total_minutos
    statistics.by_season([CURRENT_SEASON]).total["min"].to_s.chop.to_f
  end

  def por_40_minutos field
   (promedio_stat(field) / promedio_minutos * 40).round(2).to_f
  end

  def current_price
    price[CURRENT_ROUND]
  end

  def sube_15
    (( (( (current_price.to_i * 1.15) / 70000)) * (stat_field("played_games") + 1)) - total_stat("sm").to_f).round(2).to_f
  end

  def baja_15
    (( (( (current_price.to_i * 0.85) / 70000)) * (stat_field("played_games") + 1)) - total_stat("sm").to_f).round(2).to_f
  end

  def se_mantiene
    (( (( (current_price.to_i) * 1.to_f / 70000)) * (stat_field("played_games") + 1)) - total_stat("sm").to_f).round(2).to_f
  end
end