class HomeController < ApplicationController

  base_uri = 'estadisticas-back.herokuapp.com/'

  def index
    # SEO
    @page_title       = t('.title')
    @page_description = t('.description')
    @page_keywords    = t('.keywords')
    # SEO

    connection = Faraday.get ENV["API_URL"]+"games.json"
    @games = JSON.parse(connection.body)

    connection = Faraday.get ENV["API_URL"]+"statistics?season=#{ENV["CURRENT_SEASON"]}&position=base"
    @statistics_bases = JSON.parse(connection.body)

    connection = Faraday.get ENV["API_URL"]+"statistics?season=#{ENV["CURRENT_SEASON"]}&position=alero"
    @statistics_aleros = JSON.parse(connection.body)
    connection = Faraday.get ENV["API_URL"]+"statistics?season=#{ENV["CURRENT_SEASON"]}&position=pivot"
    @statistics_pivots = JSON.parse(connection.body)

    @statistics = {"base" => @statistics_bases, "alero" => @statistics_aleros, "pivot" => @statistics_pivots }
    @field = params[:field] || "v" 
    @position = params[:position] || "base"

    connection = Faraday.get ENV["API_URL"]+"players.json"
    @players = JSON.parse(connection.body)
    @indexed_players = @players.index_by {|p| p['id']}

    @positions = ["base", "alero", "pivot"]
    @positions.unshift("all") if @positions.exclude? "all"

    @num_rounds = 1
    fields = (ENV["CURRENT_ROUND"].to_i-@num_rounds..ENV["CURRENT_ROUND"].to_i-1).map{ |i| 'week_'+i.to_s}
    @round_players = []
    @round_players = @players.map{|p| {player_id: p['id'], statistic: p['statistics'].last, sum: p['statistics'].last.slice(*fields).map{|k, values| values["v"].to_f}} }.sort_by { |record| -(record[:sum]).sum.to_f }.first(10)


    @num_rounds = 3
    fields = (ENV["CURRENT_ROUND"].to_i-@num_rounds..ENV["CURRENT_ROUND"].to_i-1).map{ |i| 'week_'+i.to_s}
    @trending_players = []
    @trending_players = @players.map{|p| {player_id: p['id'], statistic: p['statistics'].last, sum: p['statistics'].last.slice(*fields).map{|k, values| values["v"].to_f}} }.sort_by { |record| -(record[:sum]).sum.to_f }.first(10)

    @round = (ENV["CURRENT_ROUND"].to_i-1).to_s

    if ENV["CURRENT_ROUND"].to_i > 1
        connection = Faraday.get ENV["API_URL"]+"games?season=#{ENV["CURRENT_SEASON"]}&round=#{ENV["CURRENT_ROUND"].to_i - 1}"
        @round_games = JSON.parse(connection.body)
    end

    connection = Faraday.get ENV["API_URL"]+"teams.json"
    @teams = JSON.parse(connection.body)

    #@top_players = Player.top_round
  end

  private
    def home_params
    end

end