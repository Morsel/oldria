require_relative '../spec_helper'

describe TrendQuestion do
  it { should belong_to :employment_search }
  it { should have_many(:admin_discussions).dependent(:destroy) }  
  it { should have_many(:restaurants).through(:admin_discussions) }  
  it { should have_many(:solo_discussions).dependent(:destroy) }   
  it { should have_many(:employments).through(:solo_discussions) }   
  it { should have_one(:soapbox_entry).dependent(:destroy) }
  it { should validate_presence_of(:subject) }
  it { should validate_presence_of(:body) }  
  it { should ensure_length_of(:slug).is_at_most(30)}


  describe "restaurants" do
    before do
      @restaurant1 = FactoryGirl.create(:restaurant, :name => "Megan's Place")
      @employment1 = FactoryGirl.create(:employment, :restaurant => @restaurant1)
      @restaurant2 = FactoryGirl.create(:restaurant, :name => "Joe's Diner")
      @employment2 = FactoryGirl.create(:employment, :restaurant => @restaurant2)
    end

    it "should update based on the search criteria" do
      employment_search = FactoryGirl.create(:employment_search, :conditions => {
        :restaurant_name_like => 'megan'
      })
      trend_question = FactoryGirl.build(:trend_question, :employment_search => employment_search)
      trend_question.save
      trend_question.restaurants.should include(@restaurant1)
      trend_question.restaurants.should_not include(@restaurant2)
    end
    
    it "should update based on the search criteria" do
      employment_search = FactoryGirl.create(:employment_search, :conditions => {
        :restaurant_name_like => 'megan'
      })
      trend_question = FactoryGirl.build(:trend_question, :employment_search => employment_search)
      trend_question.save
      trend_question.restaurants.should include(@restaurant1)
      trend_question.employment_search.conditions = {:restaurant_name_like => 'joe'}
      trend_question.save
      trend_question.restaurants.should_not include(@restaurant1)
    end
  end

  describe ".by_scheduled_date" do
    it "should return by_scheduled_date" do
      trend_question = FactoryGirl.create(:trend_question)
      TrendQuestion.by_scheduled_date.should == TrendQuestion.all(order: 'scheduled_at ASC')
    end
  end

  describe ".by_subject" do
    it "should return by_subject" do
      trend_question = FactoryGirl.create(:trend_question)
      TrendQuestion.by_subject.should == TrendQuestion.all(order: 'subject ASC')
    end
  end

  describe ".current" do
    it "should return current" do
      trend_question = FactoryGirl.create(:trend_question)
      TrendQuestion.current.should == TrendQuestion.find(:all,:conditions=>['scheduled_at < ? OR scheduled_at IS NULL', Time.zone.now])
    end
  end  

  describe ".title" do
    it "should return title" do
      trend_question = FactoryGirl.create(:trend_question)
      TrendQuestion.title.should ==  "What's New"
    end
  end  

  describe ".inbox_title" do
    it "should return inbox_title" do
      trend_question = FactoryGirl.create(:trend_question)
      trend_question.inbox_title.should ==  trend_question.class.title
    end
  end  

  describe "#mailer_method" do
    it "should return mailer_method" do
      trend_question = FactoryGirl.create(:trend_question)
      trend_question.mailer_method.should == 'answerable_message_notification'
    end
  end  
  
  describe "#message" do
    it "should return message" do
      trend_question = FactoryGirl.create(:trend_question)
      trend_question.message.should == [trend_question.subject, trend_question.body].compact.join(': ')
    end
  end  

  describe "#update_restaurants_and_employments_from_search_criteria" do
    it "should return update_restaurants_and_employments_from_search_criteria" do
      trend_question = FactoryGirl.create(:trend_question)
      trend_question.update_restaurants_and_employments_from_search_criteria.should == trend_question.employment_search.restaurant_ids
      trend_question.update_restaurants_and_employments_from_search_criteria.should == trend_question.employment_search.solo_employments
    end
  end  

  describe "#discussions" do
    it "should return discussions" do
      trend_question = FactoryGirl.create(:trend_question)
      trend_question.discussions.should == trend_question.admin_discussions + trend_question.solo_discussions
    end
  end  

  describe "#discussions_with_replies" do
    it "should return discussions_with_replies" do
      trend_question = FactoryGirl.create(:trend_question)
      trend_question.discussions_with_replies.should == trend_question.admin_discussions.with_replies + trend_question.solo_discussions.with_replies
    end
  end  

  describe "#discussions_without_replies" do
    it "should return discussions_without_replies" do
      trend_question = FactoryGirl.create(:trend_question)
      trend_question.discussions_without_replies.should == trend_question.admin_discussions.without_replies + trend_question.solo_discussions.without_replies
    end
  end  

  describe "#reply_count" do
    it "should return reply_count" do
      trend_question = FactoryGirl.create(:trend_question)
      trend_question.reply_count.should == trend_question.admin_discussions.with_replies.count + trend_question.solo_discussions.with_replies.count
    end
  end  

  describe "#comments_count" do
    it "should return comments_count" do
      trend_question = FactoryGirl.create(:trend_question)
      trend_question.comments_count.should == trend_question.admin_discussions.sum(:comments_count) + trend_question.solo_discussions.sum(:comments_count)
    end
  end  

  describe "#title" do
    it "should return title" do
      trend_question = FactoryGirl.create(:trend_question)
      trend_question.title.should == trend_question.class.title
    end
  end  

  describe "#recipients_can_reply?" do
    it "should return recipients_can_reply?" do
      trend_question = FactoryGirl.create(:trend_question)
      trend_question.recipients_can_reply?.should == true
    end
  end

  describe "#soapbox_comment_count" do
    it "should return soapbox_comment_count" do
      trend_question = FactoryGirl.create(:trend_question)
      trend_question.soapbox_comment_count.should == trend_question.discussions_with_replies.count
    end
  end
end


