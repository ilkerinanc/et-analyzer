class AddStatusToReplyToToNodes < ActiveRecord::Migration
  def change
    add_column :nodes, :status_to_reply_to, :string
  end
end
