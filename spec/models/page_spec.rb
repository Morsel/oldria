require 'spec/spec_helper'

describe Page do
  should_validate_presence_of :title
  should_validate_presence_of :slug

  describe "slug" do
    it "should auto-generate from title when blank" do
      page = Page.new(:title => 'About')
      page.generate_slug!
      page.slug.should == 'about'
    end
  end

end
