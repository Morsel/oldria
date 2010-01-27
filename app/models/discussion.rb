class Discussion < ActiveRecord::Base
  belongs_to :poster, :class_name => "User"
  has_many :discussion_seats
  has_many :users, :through => :discussion_seats
end
