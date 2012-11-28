class AddWhereToNodes < ActiveRecord::Migration
  def change
    add_column :nodes, :where, :string
  end
end
