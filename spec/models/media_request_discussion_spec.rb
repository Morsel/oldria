require 'spec/spec_helper'

describe MediaRequestDiscussion do
  should_belong_to :media_request
  should_belong_to :restaurant
end
