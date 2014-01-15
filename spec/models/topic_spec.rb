require_relative '../spec_helper'

describe Topic do
  it { should have_many(:chapters) }
  it { should have_many(:profile_questions).through(:chapters) }
  it { should validate_presence_of(:title) }
  it { should validate_uniqueness_of(:title).scoped_to(:type).case_insensitive }
  it { should ensure_length_of(:description).is_at_most(100) }

  before(:each) do
    @valid_attributes = FactoryGirl.attributes_for(:topic)
  end

  it "should create a new instance given valid attributes" do
    Topic.create!(@valid_attributes)
  end

  describe "#previous" do
    it "should return previous" do
      topic = FactoryGirl.create(:topic)
      sort_field = (topic.position == 0 ? "id" : "position")
      topic.previous.should == Topic.first(:conditions => ["topics.#{sort_field} < ?", topic.send(sort_field)], :order => "#{sort_field} DESC")
    end
  end

  describe "#next" do
    it "should return next" do
      topic = FactoryGirl.create(:topic)
      sort_field = (topic.position == 0 ? "id" : "position")
      topic.next.should == Topic.first(:conditions => ["topics.#{sort_field} > ?", topic.send(sort_field)], :order => "#{sort_field} DESC")
    end
  end

 describe "#travel" do
    it "should return travel" do
      topic = FactoryGirl.create(:topic)
      Topic.travel.should == Topic.first(:conditions => { :title => "Travel Guide" })
    end
  end

end


