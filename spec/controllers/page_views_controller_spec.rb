require_relative '../spec_helper'

describe PageViewsController do

  it "create action should render create template" do
  	page_view = FactoryGirl.create(:page_view)
    post :create, :page_view => {}
    @request.env['HTTP_ACCEPT'] = 'text/javascript'
  end

end
