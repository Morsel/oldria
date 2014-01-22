require_relative '../spec_helper'

describe MediaRequestDiscussion do
  it { should belong_to :media_request }
  it { should belong_to :restaurant }


  it "should know its employments" do
    restaurant = FactoryGirl.create(:restaurant)

    search = EmploymentSearch.new(:conditions => {:restaurant_id_eq => restaurant.id.to_s})
    media_request = FactoryGirl.create(:media_request, :employment_search => search)

    discussion = media_request.discussion_with_restaurant(restaurant)
    discussion.employments.should == restaurant.employments
  end

  describe ".with_comments" do
    it "should return with_comments" do
      media_request_discussions = FactoryGirl.create(:media_request_discussion)
      MediaRequestDiscussion.with_comments.should ==  MediaRequestDiscussion.where(:all,media_request_discussions.comments_count > 0).all
    end
  end   

  describe "#employments" do
    it "should return employments" do
      media_request_discussion = FactoryGirl.create(:media_request_discussion)
      media_request_discussion.employments.should ==  media_request_discussion.restaurant.employments.select { |e| media_request_discussion.viewable_by?(e) }
    end
  end  

  describe "#employment_ids" do
    it "should return employment_ids" do
      media_request_discussion = FactoryGirl.create(:media_request_discussion)
      media_request_discussion.employment_ids.should ==  media_request_discussion.employments.map(&:id)
    end
  end  

  describe "#users" do
    it "should return users" do
      media_request_discussion = FactoryGirl.create(:media_request_discussion)
      media_request_discussion.users.should ==  media_request_discussion.employments.map(&:employee) + [media_request_discussion.media_request.sender]
    end
  end  

  describe "#viewable_by?" do
    it "should return viewable_by?" do
      media_request_discussion = FactoryGirl.create(:media_request_discussion)
      employment = FactoryGirl.create(:employment)
      value = employment.restaurant.try(:manager) || employment.omniscient? || media_request.employment_search.employments.relation.include?(employment)
    end
  end  

  describe "#publication_string" do
    it "should return publication_string" do
      media_request_discussion = FactoryGirl.create(:media_request_discussion)
      media_request_discussion.publication_string.should ==  media_request_discussion.media_request.publication_string
    end
  end  

  describe "#email_title" do
    it "should return email_title" do
      media_request_discussion = FactoryGirl.create(:media_request_discussion)
      media_request_discussion.email_title.should ==  "Media Request"
    end
  end 

  describe "#message" do
    it "should return message" do
      media_request_discussion = FactoryGirl.create(:media_request_discussion)
      media_request_discussion.message.should ==  "#{media_request_discussion.publication_string} has a question for #{media_request_discussion.recipient_name}"
    end
  end 

  describe "#recipient_name" do
    it "should return recipient_name" do
      media_request_discussion = FactoryGirl.create(:media_request_discussion)
      media_request_discussion.recipient_name.should ==  media_request_discussion.restaurant.try(:name)
    end
  end   


end
