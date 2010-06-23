# == Schema Information
# Schema version: 20100426230131
#
# Table name: admin_discussions
#
#  id                  :integer         not null, primary key
#  restaurant_id       :integer
#  discussionable_id   :integer
#  created_at          :datetime
#  updated_at          :datetime
#  comments_count      :integer         default(0)
#  discussionable_type :string(255)
#

require 'spec/spec_helper'

describe AdminDiscussion do
  should_belong_to :restaurant
  should_belong_to :discussionable, :polymorphic => true
  # should_validate_uniqueness_of :restaurant_id, :scope => [:discussionable_id, :discussionable_type]
end
