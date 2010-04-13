# == Schema Information
# Schema version: 20100412193718
#
# Table name: admin_discussions
#
#  id                :integer         not null, primary key
#  restaurant_id     :integer
#  trend_question_id :integer
#  created_at        :datetime
#  updated_at        :datetime
#  comments_count    :integer
#

require 'spec/spec_helper'

describe AdminDiscussion do
  should_belong_to :restaurant
  should_belong_to :discussionable, :polymorphic => true
  # should_validate_uniqueness_of :restaurant_id, :scope => [:discussionable_id, :discussionable_type]
end
