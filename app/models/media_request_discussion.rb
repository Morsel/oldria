class MediaRequestDiscussion < ActiveRecord::Base
  acts_as_commentable
  belongs_to :media_request
  belongs_to :restaurant
end
