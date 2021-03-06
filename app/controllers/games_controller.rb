class GamesController < ApplicationController
  before_action :set_game, only: [:show, :update, :destroy]
  
# GET /games
  def index
    @games = Game.all

    render json: @games
  end

  # GET /games/1
  
  def getusersloc
    locids=Userlocation.select('user_id,lat,lon').where('lat is not null and lon is not null')
    usersloc=[]   
    puts locids.inspect
    locids.each do |item|
      user=User.find(item.user_id)
      usersloc.push({
              location: [item.lat, item.lon] ,
              name: user.name
            })
    end 
    render :json=> { :usersloc=>usersloc }, :status=>200    
  end
  

  def show
    render json: @game
  end

  # POST /games
  def create
    @game = Game.new(game_params)
    puts @game.inspect
    @game.user_id=current_user.id
    if @game.save
      
        ActiveRecord::Base.connection.execute(
        "INSERT INTO games_hist (id,condition_id,user_id,origin,destination,current_loc_lat, current_loc_lon,travel_mode,departure_time,car_best_opt,
        bike_best_opt,metro_best_opt,created_at,updated_at) VALUES (#{@game.id},#{@game.condition_id},#{@game.user_id},
        #{@game.origin},#{@game.destination},#{@game.current_loc_lat},#{@game.current_loc_lon},#{@game.travel_mode},
        '#{@game.departure_time}','#{@game.car_best_opt}','#{@game.bike_best_opt}','#{@game.metro_best_opt}',current_timestamp(),current_timestamp() )"
)
        
        render json: @game, status: :created, location: @game
    else
      render json: @game.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /games/1
  def update
    if @game.update(game_params)
       ActiveRecord::Base.connection.execute(
        "INSERT INTO games_hist (id,condition_id,user_id,origin,destination,current_loc_lat, current_loc_lon,travel_mode,departure_time,car_best_opt,
        bike_best_opt,metro_best_opt,created_at,updated_at) VALUES (#{@game.id},#{@game.condition_id},#{@game.user_id},
        #{@game.origin},#{@game.destination},#{@game.current_loc_lat},#{@game.current_loc_lon},#{@game.travel_mode},
        '#{@game.departure_time}','#{@game.car_best_opt}','#{@game.bike_best_opt}','#{@game.metro_best_opt}',current_timestamp(),current_timestamp() )"
)

      render json: @game
    else
      render json: @game.errors, status: :unprocessable_entity
    end
  end

  # DELETE /games/1
  def destroy
    @game.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_game
      @game = Game.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def game_params
      params.require(:game).permit(:condition_id,:user_id, :origin, :destination, :current_loc_lat, :current_loc_lon, :travel_mode, :departure_time, :car_best_opt, :bike_best_opt, :metro_best_opt)

    end
end
