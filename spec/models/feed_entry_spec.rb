# == Schema Information
#
# Table name: feed_entries
#
#  id           :integer         not null, primary key
#  title        :string(255)
#  author       :string(255)
#  url          :string(255)
#  summary      :text
#  content      :text
#  published_at :datetime
#  guid         :string(255)
#  feed_id      :integer
#  created_at   :datetime
#  updated_at   :datetime
#

require 'spec/spec_helper'

describe FeedEntry do
  before(:each) do
    @valid_attributes = Factory.attributes_for(:feed_entry)
    Factory(:feed_entry, :guid => 'a_valid_guid_000')
  end

  should_belong_to :feed
  should_validate_uniqueness_of :guid

  it "should create a new instance given valid attributes" do
    FeedEntry.create!(@valid_attributes)
  end

  it "should enforce plain-text summary" do
    f = FeedEntry.create! @valid_attributes.merge(:summary => '<img src="hello.jpg"/>no images')
    f.save
    f.summary.should == 'no images'
  end

  it "should use the content as the summary when missing" do
    f = FeedEntry.create! @valid_attributes.merge(
      :summary => '',
      :content => '<img src="hello.jpg"/>no images'
    )
    f.save
    f.summary.should == 'no images'
    f.content.should == '<img src="hello.jpg">no images'
  end

end
