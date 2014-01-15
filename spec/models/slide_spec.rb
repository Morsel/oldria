require_relative '../spec_helper'

describe Slide do
  it { should have_attached_file(:image) }
  it { should validate_attachment_content_type(:image).
                allowing("image/jpg", "image/jpeg", "image/png", "image/gif") }
  it do
    should ensure_length_of(:excerpt).
      is_at_most(200).
      with_long_message('Please shorten the text to no more than 200 characters')
  end
end

  before(:each) do
    @valid_attributes = {
      
    }
  end

  it "should create a new instance given valid attributes" do
    Slide.create!(@valid_attributes)
  end

end

