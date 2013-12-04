require_relative '../spec_helper'

describe ProfileAnswer do
  before(:each) do
    @valid_attributes = Factory.attributes_for(:profile_answer,
                                               :profile_question => Factory(:profile_question),
                                               :user => Factory(:user))
  end

  it "should create a new instance given valid attributes" do
    ProfileAnswer.create!(@valid_attributes)
  end

  describe "find answers with premium users" do

    before(:each) do |variable|
      @basic = Factory(:user, :name => "Basic")
      @premium = Factory(:user, :name => "Premium", :subscription => Factory(:subscription))
      @expired = Factory(:user, :name => "Expired", :subscription => Factory(:subscription, :end_date => 1.month.ago))
      @overtime = Factory(:user, :name => "Overtime", :subscription => Factory(:subscription, :end_date => 2.weeks.from_now))
      Factory(:profile_answer, :user => @basic)
      Factory(:profile_answer, :user => @premium)
      Factory(:profile_answer, :user => @expired)
      Factory(:profile_answer, :user => @overtime)
    end

    it "finds the right users" do
      ProfileAnswer.from_premium_users.all.map(&:user).should =~ [@premium, @overtime]
    end

  end

end

