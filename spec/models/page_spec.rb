require_relative '../spec_helper'

describe Page do
  should_validate_presence_of :title
  should_validate_presence_of :slug

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

    it { should allow_values_for :slug, "blogging_101", "welcome-to-spoonfeed"  }
    it { should_not allow_values_for :slug, "weather_man?", "why&how"  }
  end
end
