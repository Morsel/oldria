# == Schema Information
# Schema version: 20100802191740
#
# Table name: profile_questions
#
#  id         :integer         not null, primary key
#  chapter_id :integer
#  title      :string(255)
#  created_at :datetime
#  updated_at :datetime
#  position   :integer         default(0)
#

require 'spec_helper'

describe ProfileQuestion do
  before(:each) do
    @valid_attributes = Factory.attributes_for(:profile_question)
  end

  it "should create a new instance given valid attributes" do
    ProfileQuestion.create!(@valid_attributes)
  end
  
  it "should have chapters" do
    Factory(:profile_question).chapters.should be_a_kind_of(Array)
  end

  it "should have topics" do
    Factory(:profile_question).topics.should_not be_nil
  end    

end
