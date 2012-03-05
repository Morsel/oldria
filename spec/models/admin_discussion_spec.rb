require 'spec/spec_helper'

describe AdminDiscussion do
  should_belong_to :restaurant
  should_belong_to :discussionable, :polymorphic => true
  # should_validate_uniqueness_of :restaurant_id, :scope => [:discussionable_id, :discussionable_type]
end
