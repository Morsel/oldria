require_relative '../spec_helper'

describe Page do
  it { should validate_presence_of :title }
  it { should validate_presence_of :slug }

  describe "slug" do
    it "should auto-generate from title when blank" do
      page = Page.new(:title => 'About')
      page.generate_slug!
      page.slug.should == 'about'
    end

    it "should not convert to punctuation" do
      page = Page.new(:title => 'Where am I?')
      page.generate_slug!
      page.slug.should == 'where-am-i'
    end

    it { should allow_value('blogging_101').for(:slug) }
    it { should allow_value('welcome-to-spoonfeed').for(:slug) }
    it { should_not allow_value('weather_man?').for(:slug) }
    it { should_not allow_value('why&how').for(:slug) }
  end
end
