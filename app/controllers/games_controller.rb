class GamesController < ApplicationController

  def index
    # SEO
    @page_title       = t('.title', season: CURRENT_SEASON)
    @page_description = t('.description')
    @page_keywords    = t('.keywords')
    # SEO
    
    url = API_URL+"games/calendar"
    connection = Faraday.get url
    @games = JSON.parse(connection.body)
    @games = @games.group_by {|g| g['round']}
  end

  def show
    url = API_URL+"games/#{params["id"]}.json"
    connection = Faraday.get url
    @game = JSON.parse(connection.body).first

    # SEO
    @page_title       = t('.title', local: @game['local_team']['to_s'], away: @game['away_team']['to_s'])
    @page_description = t('.description', local: @game['local_team']['to_s'], away: @game['away_team']['to_s'], round: CURRENT_ROUND, season: CURRENT_SEASON)
    @page_keywords    = t('.keywords', local: @game['local_team']['to_s'], away: @game['away_team']['to_s'])
    # SEO
  end

  def round
    @round = params[:round_id].to_i
    if @round
      url = API_URL+"games?season=#{CURRENT_SEASON}&round=#{@round}"
      connection = Faraday.get url
      @round_games = JSON.parse(connection.body)
    end
  end

  private
    def find_game
      @game = Player.find(params[:id])
    end

    def game_params
      params.require(:game).permit([:name, :short_code, :active])
    end
end