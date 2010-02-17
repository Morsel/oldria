# == Schema Information
#
# Table name: discussion_seats
#
#  id            :integer         not null, primary key
#  user_id       :integer
#  discussion_id :integer
#  created_at    :datetime
#  updated_at    :datetime
#

require 'spec_helper'

describe DiscussionSeat do
  before(:all) do
    DiscussionSeat.create(:user_id => 1, :discussion_id => 1)
  end

  should_belong_to :user
  should_belong_to :discussion
end
