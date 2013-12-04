require_relative '../spec_helper'

describe MediaRequest do
  include DelayedJobSpecHelper
  should_belong_to :sender, :class_name => 'User'
  should_validate_presence_of :sender_id, :employment_search, :message

  should_belong_to :subject_matter
  should_belong_to :employment_search
  should_have_many :media_request_discussions
  should_have_many :restaurants, :through => :media_request_discussions
  should_have_many :solo_media_discussions
  should_have_many :employments, :through => :solo_media_discussions
  should_have_many :attachments, :as => :attachable, :class_name => '::Attachment', :dependent => :destroy

  before(:each) do
    @employee = Factory(:user, :username => "employee", :email => "employee@example.com")
    @restaurant = Factory(:restaurant, :name => "Joe's Crab Shack")
    @employment = Factory(:employment, :restaurant => @restaurant, :employee => @employee)
    @employment_search = Factory(:employment_search, :conditions => {:employee_id_eq => @employee.id.to_s})
  end

  describe "senders and receivers" do

    it "should build discussions with other folks" do
      mr = Factory(:media_request, :employment_search => @employment_search)
      mr.media_request_discussions.first.restaurant.should == @restaurant
      @restaurant.media_request_discussions.first.media_request.should == mr
    end

    describe "finding" do
      before do
        @media_request = Factory(:media_request, :employment_search => @employment_search)
      end

      it "conversation by way of restaurant should include the first conversation" do
        @media_request.discussion_with_restaurant(@restaurant).should be_a(MediaRequestDiscussion)
      end

      it "restaurants" do
        @media_request.restaurants.should == [@restaurant]
      end
    end
  end

  describe "with search criteria" do
    before do
      @restaurant2 = Factory(:restaurant, :name => "IHOP")
    end
    it "should update based on the search criteria" do
      employment_search = Factory(:employment_search, :conditions => {
        :restaurant_name_like => @restaurant.name
      })
      media_request = Factory.build(:media_request, :employment_search => employment_search)
      media_request.save
      media_request.restaurant_ids.should == [@restaurant.id]

      media_request.employment_search.conditions = {:restaurant_name_like => 'nobody'}
      media_request.save
      media_request.restaurants.should_not include(@restaurant)
    end
  end

  describe "fields" do
    before(:each) do
      @request = Factory.build(:media_request, :employment_search => @employment_search)
      @request.stubs(:restaurant_ids).returns([1])
    end

    it "should be empty Hash for new instance" do
      @request.fields.should == {}
    end

    it "should be a hash with keys and values" do
      @request.fields = {:hello => "No!"}
      @request.fields.should be_a(Hash)
      @request.save
      MediaRequest.find(@request.id).fields.should be_a(Hash)
    end

    it "should reject blank values" do
      @request.fields = {:hello => '', :nothing => "Booya!"}
      @request.fields[:hello].should be_nil
    end
  end

  describe "message_with_fields" do
    before(:each) do
      @request = Factory.build(:media_request, :employment_search => @employment_search)
    end

    it "should join a field and the message" do
      @request.message = "This is a message"
      @request.fields = {:date => "December 10"}
      @request.message_with_fields.should == <<-EOT.gsub(/^[ ]+/,'').chomp
      Date: December 10

      This is a message
      EOT
    end

    it "should join all fields and the message" do
      @request.message = "Messages are neat"
      @request.fields = {:photo_requirements => "8x10 large", :time_of_event => "10am"}
      @request.message_with_fields.should include("Photo requirements: 8x10 large")
      @request.message_with_fields.should include("Time of event: 10am")
      @request.message_with_fields.should include("Messages are neat")
    end
  end

  describe "status" do
    before(:each) do
      @request = Factory.build(:media_request, :employment_search => @employment_search)
    end

    it "should start out pending" do
      @request.should be_pending
    end

    it "should be approvable" do
      UserMailer.stubs(:deliver_media_request_notification).returns(true)
      @media_request = Factory(:pending_media_request, :employment_search => @employment_search)
      @media_request.approve
      @media_request.save
      @media_request.should_not be_pending
      @media_request.should be_approved
    end

    it "should be sent to each restaurant on approval" do
      @request = Factory.build(:pending_media_request, :status => 'pending')
      @request.employment_search.stubs(:restaurant_ids).returns([@restaurant.id])
      @request.stubs(:restaurant_ids).returns([@restaurant.id])
      @request.save
      @request.media_request_discussions.each do |discussion|
        discussion.stubs(:employments).returns([@employment])
      end
      UserMailer.expects(:deliver_media_request_notification)
      @request.deliver_notifications
      perform_delayed_jobs
    end
  end

end

