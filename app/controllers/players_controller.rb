class PlayersController < ApplicationController

  include ActionView::Helpers::NumberHelper

  def index
    # SEO
    @page_title       = t('.title', season: CURRENT_SEASON)
    @page_description = t('.description')
    @page_keywords    = t('.keywords')
    # SEO

    players_scope = Player.active.includes(:team)
    players_scope = players_scope.where("lower(players.name) ILIKE ?", "%#{params[:name].downcase}%") unless params[:name].blank?
    players_scope = players_scope.where("players.team_id = ?", params[:team_id]) unless params[:team_id].blank?
    players_scope = players_scope.where("players.position = ?", params[:position]) unless params[:position].blank?

    smart_listing_create :players, players_scope, partial: "players/listing"
  end

  def show
    url = API_URL+"players/#{params["id"]}.json"
    connection = Faraday.get url
    @player = JSON.parse(connection.body).first

    # SEO
    @page_title       = t('.title', player: @player['name'], season: CURRENT_SEASON)
    @page_description = t('.description', player: @player['name'], season: CURRENT_SEASON)
    @page_keywords    = t('.keywords', player: @player['name'])
    # SEO

    #fields = ['week_1', 'week_2', 'week_3', 'week_4', 'week_5']
    fields = (1...CURRENT_ROUND.to_i).map{ |i| 'week_'+i.to_s}

    prices = @player['price']
    prices = prices.except!("0")
    prices = prices.except!(CURRENT_ROUND)
    
    @broker_data = { 
      labels: prices.keys.map{|key| [t("round"), key.to_s].join(" ")}, 
      datasets: [
        { label: "Brokerbasket", 
          backgroundColor: "rgb(226, 106, 124)", 
          borderColor: "rgb(214, 12, 43)", 
          data: prices.values
        }
      ]
    }
    @stats_data = { 
      labels:(1...CURRENT_ROUND.to_i).map{|key| [t("round"), key.to_s].join(" ")}, 
      datasets: [
        { label: "SuperManager", 
          borderColor: "rgb(146, 43, 33)", 
          data: @player['statistics'].last.slice(*fields).map{|k, values| values["sm"].to_f}
        },
        { label: "Valoración", 
          borderColor: "rgb(118, 68, 138)", 
          data: @player['statistics'].last.slice(*fields).map{|k, values| values["v"].to_f}
        },
        { label: "Puntos", 
          borderColor: "rgb(31, 97, 141)", 
          data: @player['statistics'].last.slice(*fields).map{|k, values| values["pt"].to_f}
        },
        { label: "Rebotes", 
          borderColor: "rgb(20, 143, 119)", 
          data: @player['statistics'].last.slice(*fields).map{|k, values| values["reb"].to_f}
        },
        { label: "Asistencias", 
          borderColor: "rgb(30, 132, 73)", 
          data: @player['statistics'].last.slice(*fields).map{|k, values| values["a"].to_f}
        },
        { label: "Triples", 
          borderColor: "rgb(183, 149, 11)", 
         data: @player['statistics'].last.slice(*fields).map{|k, values| values["t2"].to_f}
        }
      ]
    }
    @options = {}  
  end

  def brokerbasket
    # SEO
    @page_title       = t('.title')
    @page_description = t('.description')
    @page_keywords    = t('.keywords')
    # SEO

    connection = Faraday.get API_URL+"players?season=#{CURRENT_SEASON}&position=base"
    @players_bases = JSON.parse(connection.body)

    connection = Faraday.get API_URL+"players?season=#{CURRENT_SEASON}&position=alero"
    @players_aleros = JSON.parse(connection.body)

    connection = Faraday.get API_URL+"players?season=#{CURRENT_SEASON}&position=pivot"
    @players_pivots = JSON.parse(connection.body)

    @players_group_by_position = {"base" => @players_bases, "alero" => @players_aleros, "pivot" => @players_pivots }

    @position = params[:position] || "base" 
    connection = Faraday.get API_URL+"players.json"
    @players = JSON.parse(connection.body)
  end

  def historico
    # SEO
    @page_title       = t('.title')
    @page_description = t('.description')
    @page_keywords    = t('.keywords')
    # SEO

    #params
    @num_rounds = params[:num_rounds] ? params[:num_rounds].to_i : 3
    @position = params[:position] ? params[:position] : "all"
    @field = params[:field] || "v"

    @positions = POSITIONS
    @positions.unshift("all") if @positions.exclude? "all"

    connection = Faraday.get API_URL+"players.json"
    @players = JSON.parse(connection.body)
    @indexed_players = @players.index_by {|p| p['id']}

    fields = (CURRENT_ROUND.to_i-@num_rounds..CURRENT_ROUND.to_i-1).map{ |i| 'week_'+i.to_s}
    unless @position == "all"
      connection = Faraday.get API_URL+"players?season=#{CURRENT_SEASON}&position=#{@position}"
      @players = JSON.parse(connection.body)
    end
    
    @trending_players = @players.map{|p| {player_id: p['id'], statistic: p['statistics'].last, sum: p['statistics'].last.slice(*fields).map{|k, values| values[@field].to_f}} }.sort_by { |record| -(record[:sum]).sum.to_f }

    @round = (CURRENT_ROUND.to_i-1).to_s
  end

  def temporada
    # SEO
    @page_title       = t('.title')
    @page_description = t('.description')
    @page_keywords    = t('.keywords')
    # SEO

    #params
    @num_rounds = CURRENT_ROUND.to_i-1
    @position = params[:position] ? params[:position] : "all"
    @field = params[:field] || "v"

    @positions = POSITIONS
    @positions.unshift("all") if @positions.exclude? "all"

    connection = Faraday.get API_URL+"players.json"
    @players = JSON.parse(connection.body)
    @indexed_players = @players.index_by {|p| p['id']}

    fields = (CURRENT_ROUND.to_i-@num_rounds..CURRENT_ROUND.to_i-1).map{ |i| 'week_'+i.to_s}
    unless @position == "all"
      connection = Faraday.get API_URL+"players?season=#{CURRENT_SEASON}&position=#{@position}"
      @players = JSON.parse(connection.body)
    end
    
    @temporada_players = @players.map{|p| {player_id: p['id'], statistic: p['statistics'].last, promedio: p['statistics'].last['promedio'][@field], sum: p['statistics'].last.slice(*fields).map{|k, values| values[@field].to_f}} }.sort_by { |record| -(record[:promedio]).to_f }

    @round = (CURRENT_ROUND.to_i-1).to_s
  end


  def mejores_jornada
    # SEO
    @page_title       = t('.title')
    @page_description = t('.description')
    @page_keywords    = t('.keywords')
    # SEO

    #params
    @num_rounds = 1
    @position = params[:position] ? params[:position] : "all"
    @field = params[:field] || "v"

    @positions = POSITIONS
    @positions.unshift("all") if @positions.exclude? "all"

    connection = Faraday.get API_URL+"players.json"
    @players = JSON.parse(connection.body)
    @indexed_players = @players.index_by {|p| p['id']}

    unless @position == "all"
      connection = Faraday.get API_URL+"players?season=#{CURRENT_SEASON}&position=#{@position}"
      @players = JSON.parse(connection.body)
    end

    fields = (CURRENT_ROUND.to_i-@num_rounds..CURRENT_ROUND.to_i-1).map{ |i| 'week_'+i.to_s}    
    @best_players = @players.map{|p| {player_id: p['id'], statistic: p['statistics'].last, sum: p['statistics'].last.slice(*fields).map{|k, values| values[@field].to_f}} }.sort_by { |record| -(record[:sum]).sum.to_f }

    @round = (CURRENT_ROUND.to_i-1).to_s
  end

  def comparar
    url = API_URL+"players/#{params["player_1_id"]}.json"
    connection = Faraday.get url
    @player_1_id = JSON.parse(connection.body).first if params[:player_1_id] and !params[:player_1_id].blank?

    url = API_URL+"players/#{params["player_2_id"]}.json"
    connection = Faraday.get url
    @player_2_id = JSON.parse(connection.body).first if params[:player_2_id] and !params[:player_2_id].blank?

    @fields = (1...CURRENT_ROUND.to_i).map{ |i| 'week_'+i.to_s}
  end

  def search
    url = API_URL+"players?name=#{params[:q]}"
    connection = Faraday.get url
    @players = JSON.parse(connection.body)

    @player1 = params[:player1]
    @player2 = params[:player2]
    respond_to do |format|
      format.js {
      }
    end
  end

  private
    def find_player
      @player = Player.find(params[:id])
    end

    def player_params
      params.require(:player).permit([:name, :position, :team_id, :href, :active, :best_round_val, :best_round_points, :best_round_rebounds, :best_round_assists, :best_round_3points])
    end
end