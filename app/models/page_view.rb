# == Schema Information
#
# Table name: page_views
#
#  id              :integer         not null, primary key
#  user_id         :integer
#  title           :string(255)
#  url             :string(255)
#  created_at      :datetime
#  updated_at      :datetime
#  page_owner_id   :integer
#  page_owner_type :string(255)
#

class PageView < ActiveRecord::Base

  validates_presence_of :url, :title, :user_id

  belongs_to :user
  belongs_to :page_owner, :polymorphic => true
  attr_accessible :url, :user_id, :title, :page_owner_id, :page_owner_type,:page_type, :page_id

end
