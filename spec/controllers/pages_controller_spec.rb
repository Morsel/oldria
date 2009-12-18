require File.dirname(__FILE__) + '/../spec_helper'
 
describe PagesController do
  integrate_views
  before(:each) do
    Factory(:page)
  end

  it "show action should render show template" do
    get :show, :id => Page.first
    response.should render_template(:show)
  end
end
