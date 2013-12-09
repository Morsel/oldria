# == Schema Information
# Schema version: 20120217190417
#
# Table name: user_editors
#
#  id         :integer         not null, primary key
#  user_id    :integer
#  editor_id  :integer
#  created_at :datetime
#  updated_at :datetime
#

class UserEditor < ActiveRecord::Base

  belongs_to :user
  belongs_to :editor, :class_name => "User"
  attr_accessible :user_id, :editor_id
end
