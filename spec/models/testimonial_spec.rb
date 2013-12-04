require_relative '../spec_helper'

describe Testimonial do
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
end

