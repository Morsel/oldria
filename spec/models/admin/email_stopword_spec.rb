require_relative '../../spec_helper'

describe Admin::EmailStopword do
	it { should validate_presence_of(:phrase) }

  before(:each) do
    @valid_attributes = {
      :phrase => "value for phrase"
    }
  end

  it "should create a new instance given valid attributes" do
    Admin::EmailStopword.create!(@valid_attributes)
  end
end
