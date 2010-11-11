# == Schema Information
#
# Table name: soapbox_pages
#
#  id         :integer         not null, primary key
#  title      :string(255)
#  slug       :string(255)
#  content    :text
#  created_at :datetime
#  updated_at :datetime
#

require 'spec_helper'

describe SoapboxPage do
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
