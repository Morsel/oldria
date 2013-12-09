require_relative '../spec_helper'

describe ProfileAnswer do
  before(:each) do
    @valid_attributes = FactoryGirl.attributes_for(:profile_answer)
    @valid_attributes[:profile_question] = FactoryGirl.create(:profile_question)
    @valid_attributes[:user] = FactoryGirl.create(:user)
  end

  it "should create a new instance given valid attributes" do
    ProfileAnswer.create!(@valid_attributes)
  end

  describe "find answers with premium users" do

    before(:each) do |variable|
      @basic = FactoryGirl.create(:user, :name => "Basic")
      @premium = FactoryGirl.create(:user, :name => "Premium", :subscription => FactoryGirl.create(:subscription))
      @expired = FactoryGirl.create(:user, :name => "Expired", :subscription => FactoryGirl.create(:subscription, :end_date => 1.month.ago))
      @overtime = FactoryGirl.create(:user, :name => "Overtime", :subscription => FactoryGirl.create(:subscription, :end_date => 2.weeks.from_now))
      FactoryGirl.create(:profile_answer, :user => @basic)
      FactoryGirl.create(:profile_answer, :user => @premium)
      FactoryGirl.create(:profile_answer, :user => @expired)
      FactoryGirl.create(:profile_answer, :user => @overtime)
    end

    it "finds the right users" do
      ProfileAnswer.from_premium_users.all.map(&:user).should =~ [@premium, @overtime]
    end

  end

end

