class RemoveLongLatFromNodes < ActiveRecord::Migration
  def up
    remove_column :nodes, :lat
    remove_column :nodes, :long
    remove_column :nodes, :where
  end

  def down
    add_column :nodes, :where, :string
    add_column :nodes, :long, :string
    add_column :nodes, :lat, :string
  end
end
