require 'spec_helper'

describe DiscussionSeat do
  should_belong_to :user
  should_belong_to :discussion
end
