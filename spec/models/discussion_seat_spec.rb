require_relative '../spec_helper'

describe DiscussionSeat do
  before(:all) do
    DiscussionSeat.create(:user_id => 1, :discussion_id => 1)
  end

  should_belong_to :user
  should_belong_to :discussion
end
