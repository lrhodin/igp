class Album < ActiveRecord::Base
  has_many :videos
end
