# == Schema Information
#
# Table name: media_request_conversations
#
#  id               :integer         not null, primary key
#  media_request_id :integer
#  recipient_id     :integer
#  created_at       :datetime
#  updated_at       :datetime
#  comments_count   :integer         default(0)
#

require 'spec/spec_helper'

describe MediaRequestConversation do
  should_belong_to :media_request
  should_belong_to :recipient, :class_name => "Employment"
end
