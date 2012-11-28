class CreateNodes < ActiveRecord::Migration
  def change
    create_table :nodes do |t|
      t.integer :author_id
      t.integer :tid
      t.text :value
      t.integer :in_reply_to_tid
      t.string :permalink
      t.datetime :posted_at
      t.integer :category_id
      t.string :what
      t.string :location
      t.integer :long
      t.integer :lat
      t.integer :amount
      t.text :extra

      t.timestamps
    end
  end
end
