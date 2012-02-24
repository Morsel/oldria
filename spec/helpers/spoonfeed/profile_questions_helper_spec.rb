require 'spec_helper'

describe Spoonfeed::ProfileQuestionsHelper do

  it "btl_description_for_fb should return excerpt from answers" do
    answer = Object.new
    answer.stubs(:answer).returns('a')
    btl_description_for_fb([answer]).should == "a"
    btl_description_for_fb([answer]*2).should == "a | a"
  end

end
