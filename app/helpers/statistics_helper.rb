module StatisticsHelper

  def stat_field player, field, season
    player['statistics'].last['field'].to_f
  end

  def promedio_stat player, field, season
    player['statistics'].last['promedio'][field].to_f
  end

  def total_stat player, field, season
    player['statistics'].last[field].to_f
  end

  def played_games player, season
    player['statistics'].last['played_games'].to_i
  end

  def promedio_minutos player, season
    player['statistics'].last['promedio']['min'].to_s.chop.to_f
  end

  def total_minutos player, season
    player['statistics'].last['total']['min'].to_s.chop.to_f
  end

  def por_40_minutos player, field, season
   (promedio_stat(player, field, season) / promedio_minutos(player, season) * 40).round(2)
  end

  def sube_15 player, season
    (( (( (current_price(player) * 1.15) / 70000)) * (stat_field(player, "played_games", season) + 1)) - total_stat(player, "sm", season)).round(2)
  end

  def baja_15 player, season
    (( (( (current_price(player) * 0.85) / 70000)) * (stat_field(player, "played_games", season) + 1)) - total_stat(player, "sm", season)).round(2)
  end

  def se_mantiene player, season
    (( (( (current_price(player)) * 1 / 70000)) * (stat_field(player, "played_games", season) + 1)) - total_stat(player, "sm", season)).round(2)
  end

end