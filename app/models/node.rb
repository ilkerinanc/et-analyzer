class Node < ActiveRecord::Base
  attr_accessible :amount, :author_id, :category_id, :extra, :in_reply_to_tid, :lat, :location, :long, :permalink, :posted_at, :tid, :value, :what
  geocoded_by :location
  after_validation :geocode
end
