# == Schema Information
# Schema version: 20110915181800
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

end
