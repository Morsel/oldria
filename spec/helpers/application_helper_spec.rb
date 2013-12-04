require_relative '../spec_helper'

describe ApplicationHelper do
  include ApplicationHelper

  describe "div if" do

    it "should return blank if false" do
      content = div_if(false) {"fred"}
      content.should == ""
    end

    it "should return a div if true" do
      content = div_if(true, :id => "dom_id") {"fred"}
      content.should == "<div id=\"dom_id\">fred</div>"
    end

  end

end