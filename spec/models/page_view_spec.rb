require_relative '../spec_helper'

describe PageView do
  it { should validate_presence_of(:url) }
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:user_id) }
  it { should belong_to(:user) }
  it { should belong_to(:page_owner) }

  before(:each) do
    @valid_attributes = {
      :user_id => 1,
      :title => "value for title",
      :url => "value for url"
    }
  end

  it "should create a new instance given valid attributes" do
    PageView.create!(@valid_attributes)
  end
end
