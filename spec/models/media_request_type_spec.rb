require_relative '../spec_helper'

describe MediaRequestType do

  before(:each) do
    @valid_attributes = FactoryGirl.attributes_for(:media_request_type)
  end

  it "should create a new instance given valid attributes" do
    MediaRequestType.create!(@valid_attributes)
  end
 

  describe "#fieldset" do
    it "should return the fieldset" do
    	media_request_type = FactoryGirl.create(:media_request_type)
      @fieldset = (media_request_type.fields || "").split(/, */).map do |field|
        field.gsub(/\s+/, '_').downcase
      end
      media_request_type.fieldset.should == @fieldset
    end 
  end

end
