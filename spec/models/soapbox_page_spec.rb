require_relative '../spec_helper'

describe SoapboxPage do
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:slug) }  
  it do
    should_not allow_value(/^[\w\d_\-]+$/).
      for(:slug).
      with_message('can only contain lowercase letters, numbers, underscores (_) and dashes (-)')
  end


  before(:each) do
    @valid_attributes = {
      :title => "value for title",
      :slug => "value-for-slug",
      :content => "value for content"
    }
  end

  it "should create a new instance given valid attributes" do
    SoapboxPage.create!(@valid_attributes)
  end
end
