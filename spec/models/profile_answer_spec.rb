require_relative '../spec_helper'

describe ProfileAnswer do
  it { should belong_to(:profile_question) }
  it { should belong_to(:user) }
  it { should validate_presence_of(:answer) }
  it { should validate_presence_of(:profile_question_id) }
  it { should validate_presence_of(:user_id) }
  it { should validate_uniqueness_of(:profile_question_id).scoped_to(:user_id) }
  it { should ensure_length_of(:answer).is_at_most(2000) }  

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

  describe "#question" do
    it "should return question" do
      profile_answer = FactoryGirl.build(:profile_answer)
      profile_answer.question.should == profile_answer.profile_question.title
    end
  end

  describe "#chapter_id" do
    it "should return chapter_id" do
      profile_answer = FactoryGirl.build(:profile_answer)
      profile_answer.chapter_id.should == profile_answer.profile_question.chapter.id
    end
  end

  describe "#activity_name" do
    it "should return activity name" do
      profile_answer = FactoryGirl.build(:profile_answer)
      profile_answer.activity_name.should == "Behind the Line"
    end
  end

end

