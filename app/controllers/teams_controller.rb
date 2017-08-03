class TeamsController < ApplicationController

  def index
    url = ENV["API_URL"]+"teams.json"
    connection = Faraday.get url
    @teams = JSON.parse(connection.body)

    # SEO
    @page_title       = t('.title', season: ENV["CURRENT_SEASON"])
    @page_description = t('.description', season: ENV["CURRENT_SEASON"])
    @page_keywords    = t('.keywords')
    # SEO
  end

  def show
    url = ENV["API_URL"]+"teams/#{params["id"]}.json"
    connection = Faraday.get url
    @team = JSON.parse(connection.body).first

    # SEO
    @page_title       = t('.title', team: @team['name'])
    @page_description = t('.description', team: @team['name'], season: ENV["CURRENT_SEASON"])
    @page_keywords    = t('.keywords', team: @team['name'])
    # SEO
  end

  private
    def team_params
      params.require(:team).permit([:name, :second_name, :short_code, :rest_round_1, :rest_round_2, :active])
    end
end