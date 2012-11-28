class AddLongitudeLatitudeToNodes < ActiveRecord::Migration
  def change
    add_column :nodes, :latitude, :float
    add_column :nodes, :longitude, :float
  end
end
