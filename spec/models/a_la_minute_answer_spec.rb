require 'spec_helper'

describe ALaMinuteAnswer do
  before(:each) do
    @valid_attributes = {
      :answer => "value for answer",
      :a_la_minute_question_id => 1,
      :responder_id => 1,
      :responder_type => "value for responder_type"
    }
  end

  it "should create a new instance given valid attributes" do
    ALaMinuteAnswer.create!(@valid_attributes)
  end
end
