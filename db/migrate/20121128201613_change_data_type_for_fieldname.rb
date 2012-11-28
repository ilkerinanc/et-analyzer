class ChangeDataTypeForFieldname < ActiveRecord::Migration
  def self.up
    change_table :nodes do |t|
      t.change :tid, :string
      t.change :in_reply_to_tid, :string
    end
  end
end
