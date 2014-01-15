require_relative '../spec_helper'

describe Testimonial do
  it { should have_attached_file(:photo) }
  it { should validate_attachment_content_type(:photo).
                  allowing("image/jpg", "image/jpeg", "image/png", "image/gif", "image/pjpeg", "image/x-png") }
  it { should validate_presence_of(:person) }
  it { should validate_presence_of(:quote) }
  it { should validate_presence_of(:photo) }
  it { should validate_presence_of(:page) }


  before(:each) do
    @valid_attributes = {
      :person => "value for person",
      :quote => "value for quote",
      :photo_file_name => "photo.jpg",
      :photo_content_type => "image/jpg",
      :photo_file_size => 1,
      :photo_updated_at => Time.now,
      :page => "RIA HQ"
    }
  end

  it "should create a new instance given valid attributes" do
    Testimonial.create!(@valid_attributes)
  end
  
  describe "#page_options" do
    it "should return page_options" do
      feature = FactoryGirl.create(:restaurant_feature)
      restaurant = FactoryGirl.create(:restaurant)
      Testimonial.page_options.should == ["RIA HQ", "Spoonfeed"]
    end
  end  


end

