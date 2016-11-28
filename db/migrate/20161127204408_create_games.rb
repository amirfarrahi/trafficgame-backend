class CreateGames < ActiveRecord::Migration[5.0]
  def change
    create_table :games do |t|
      t.integer :condition_id
      t.integer :user_id
      t.integer :origin
      t.integer :destination
      t.float :current_loc_lat
      t.float :current_loc_lon
      t.integer :travel_mode
      t.text :departure_time
      t.text :car_best_opt
      t.text :bike_best_opt
      t.text :metro_best_opt

      t.timestamps
    end
  end
end
