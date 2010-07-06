class MediaRequestDiscussion < ActiveRecord::Base
  belongs_to :media_request
  belongs_to :restaurant
end
