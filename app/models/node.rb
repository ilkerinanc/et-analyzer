class Node < ActiveRecord::Base
  attr_accessible :amount, :author_id, :category_id, :extra, :in_reply_to_tid, :lat, :location, :long, :permalink, :posted_at, :tid, :value, :what, :status_to_reply_to, :parent_id, :status
  has_many :children, :class_name => "Node", :foreign_key => "parent_id"
  geocoded_by :location
  after_validation :geocode
end
