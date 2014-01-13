require_relative '../spec_helper'

describe ProfileQuestion do
  before(:each) do
    @valid_attributes = FactoryGirl.attributes_for(:profile_question)
    @valid_attributes[:chapter] = FactoryGirl.create(:chapter)
  end

  it { should belong_to :chapter }
  it { should have_many(:question_roles).dependent(:destroy) }
  it { should have_many(:profile_answers).dependent(:destroy) }
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:chapter_id) }    
  it { should validate_uniqueness_of(:title).scoped_to(:chapter_id).case_insensitive }

  it "should create a new instance given valid attributes" do
    ProfileQuestion.create!(@valid_attributes)
  end

  it "should have a topic" do
    FactoryGirl.create(:profile_question).topic.should_not be_nil
  end

  it "should be able to tell whether a user has answered it" do
    user = FactoryGirl.create(:user)
    question = FactoryGirl.create(:profile_question)
    question.answered_by?(user).should be_false
    FactoryGirl.create(:profile_answer, :user => user, :profile_question => question)
  end

  describe "#topic" do
    it "should return the topic" do
      profile_question = FactoryGirl.create(:profile_question)
      profile_question.topic.should == profile_question.chapter.topic
    end  
  end  

  describe "#answered_by?" do
    it "should return answered_by?" do
      profile_question = FactoryGirl.create(:profile_question)
      user = FactoryGirl.create(:user)
      profile_question.answered_by?(user).should == profile_question.profile_answers.exists?(:user_id => user.id)
    end  
  end  

  describe "#answer_for" do
    it "should return answer_for" do
      profile_question = FactoryGirl.create(:profile_question)
      user = FactoryGirl.create(:user)
      profile_question.answer_for(user).should == profile_question.profile_answers.select { |a| a.user == user }.first
    end  
  end  

  # describe "#find_or_build_answer_for" do
  #   it "should return find_or_build_answer_for" do
  #     profile_question = FactoryGirl.create(:profile_question)
  #     user = FactoryGirl.create(:user)
  #     profile_question.find_or_build_answer_for(user).should == profile_question.answered_by?(user) ? profile_question.answer_for(user) :  profile_question.profile_answers.build(:user => user)
  #   end  
  # end  

  describe "#latest_answer" do
    it "should return latest_answer" do
      profile_question = FactoryGirl.create(:profile_question)
      profile_question.latest_answer.should == profile_question.profile_answers.first(:order => "created_at DESC")
    end  
  end  

  describe "#latest_soapbox_answer" do
    it "should return latest_soapbox_answer" do
      profile_question = FactoryGirl.create(:profile_question)
      profile_question.latest_soapbox_answer.should == profile_question.profile_answers.from_premium_users.from_public_users.first(:order => "created_at DESC")
    end  
  end    

  describe "#soapbox_answer_count" do
    it "should return soapbox_answer_count" do
      profile_question = FactoryGirl.create(:profile_question)
      profile_question.soapbox_answer_count.should == profile_question.profile_answers.from_premium_users.from_public_users.count
    end  
  end    

  describe "#users_with_answers" do
    it "should return users_with_answers" do
      profile_question = FactoryGirl.create(:profile_question)
      profile_question.users_with_answers.should == profile_question.profile_answers.map(&:user).uniq
    end  
  end    

  describe "#users_without_answers" do
    it "should return users_without_answers" do
      profile_question = FactoryGirl.create(:profile_question)
      ids = profile_question.profile_answers.map(&:user_id)
      if ids.present?
      users_without_answers = profile_question.restaurant_roles.map { |r| r.employees.all(:conditions => ["users.id NOT IN (?)", ids]) }.flatten.uniq
      else
      users_without_answers = profile_question.restaurant_roles.map { |r| r.employees.all }.flatten.uniq
      end   
      profile_question.users_without_answers.should == users_without_answers
    end  
  end    

  describe "#email_title" do
    it "should return email_title" do
      profile_question = FactoryGirl.create(:profile_question)
      profile_question.email_title.should == "Behind the Line"
    end  
  end    

  describe "#short_title" do
    it "should return short_title" do
      profile_question = FactoryGirl.create(:profile_question)
      profile_question.short_title.should == "btl"
    end  
  end    

  describe "#email_body" do
    it "should return email_body" do
      profile_question = FactoryGirl.create(:profile_question)
      profile_question.email_body.should == profile_question.title
    end  
  end      

end


