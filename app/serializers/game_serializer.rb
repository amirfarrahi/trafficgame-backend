class GameSerializer < ActiveModel::Serializer
  attributes :id,:condition_id,:user_id, :origin, :destination, :current_loc_lat, :current_loc_lon, :travel_mode, :departure_time, :car_best_opt, :bike_best_opt, :metro_best_opt
end
