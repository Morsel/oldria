require_relative '../spec_helper'
include ActionDispatch::TestProcess

describe MenuItem do

it { should belong_to(:restaurant) }  
  it { should have_many(:menu_item_keywords).dependent(:destroy) }
  it { should have_many(:otm_keywords).through(:menu_item_keywords) } 
  it { should have_many(:trace_keywords) }
  it { should have_many(:soapbox_trace_keywords) }
  it { should have_many(:twitter_posts).dependent(:destroy) }
  it { should have_many(:facebook_posts).dependent(:destroy) }
  it { should validate_attachment_size(:photo).
                less_than(3.megabytes) }
  it { should validate_attachment_content_type(:photo).
                allowing("image/jpg", "image/jpeg", "image/png", "image/gif", "image/pjpeg", "image/x-png") }              

  it { should validate_presence_of(:name) }       
  it { should validate_presence_of(:description) }
  it { should validate_presence_of(:restaurant) }
  it { should validate_presence_of(:photo) }
  it do
    should_not allow_value(RestaurantFactSheet::MONEY_FORMAT).
      for(:price)
  end




  # before(:each) do
  #     @restaurant = FactoryGirl.create(:restaurant, :atoken => "asdfgh", :asecret => "1234567", :facebook_page_id => "987987213", :facebook_page_token => "kljas987as")
  #   @valid_attributes = FactoryGirl.attributes_for(:menu_item, :otm_keywords => [FactoryGirl.create(:otm_keyword)], :restaurant => @restaurant)
  #   MenuItem.any_instance.stubs(:restaurant).returns(@restaurant)
  #   test_photo = ActionDispatch::Http::UploadedFile.new({
  #     :filename => 'index.jpeg',
  #     :type => 'image/jpeg',
  #     :tempfile => File.new("#{Rails.root}/spec/fixtures/index.jpeg")
  #   })
  #   @valid_attributes[:photo] = test_photo
  # end

  # it "should create a new instance given valid attributes" do
  #   MenuItem.create!(@valid_attributes)
  # end

  # it "should schedule a crosspost to Twitter" do
  #   twitter_client = mock
  #   @restaurant.stubs(:twitter_client).returns(twitter_client)
  #   # twitter_client.expects(:send_at).returns(true)
  #   MenuItem.create(@valid_attributes.merge(:post_to_twitter_at => (Time.now + 5.hours)))
  # end
  # # #crosspost attribute now remove CIS
  # # it "should not crosspost to Twitter when no crosspost flag is set" do
  # #   @restaurant.expects(:twitter_client).never
  # #   MenuItem.create(@valid_attributes.merge(:post_to_twitter_at => Time.now, :no_twitter_crosspost => "1"))
  # # end

  # it "should schedule a crosspost to Facebook" do
  #   # @restaurant.expects(:send_at).returns(true)
  #   MenuItem.create(@valid_attributes.merge(:post_to_facebook_at => (Time.now + 5.hours)))
  # end
  # # #crosspost attribute now remove CIS
  # # it "should not crosspost to Facebook when no crosspost flag is set" do
  # #   @restaurant.expects(:send_at).never
  # #   MenuItem.create(@valid_attributes.merge(:post_to_facebook_at => Time.now, :no_fb_crosspost => "1"))
  # # end

end

