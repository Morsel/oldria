require_relative '../spec_helper'

describe AdminDiscussion do
  it { should belong_to :restaurant }
  it { should belong_to :discussionable } #, :polymorphic => true }
  # should_validate_uniqueness_of :restaurant_id, :scope => [:discussionable_id, :discussionable_type]
end
