require 'spec/spec_helper'

describe MediaRequestConversation do
  should_belong_to :media_request
  should_belong_to :recipient, :class_name => "Employment"
end
