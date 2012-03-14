# == Schema Information
#
# Table name: page_views
#
#  id         :integer         not null, primary key
#  user_id    :integer
#  title      :string(255)
#  url        :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class PageView < ActiveRecord::Base

  validates_presence_of :url, :title, :user_id

  belongs_to :user

end
