require_relative '../../spec_helper'

describe Soapbox::BehindTheLineController do

  before(:each) do
    fake_admin_user
    FactoryGirl.create(:mediafeed_slide)
  end

  it "topic action should render topic template" do
  	@topic = FactoryGirl.create(:topic)
    get :topic,:id=>@topic.id 
    response.should render_template(:topic)
  end

  it "topic action should render chapter template" do
  	@chapter = FactoryGirl.create(:chapter)
    get :chapter,:id=>@chapter.id 
    response.should render_template(:chapter)
  end

end
