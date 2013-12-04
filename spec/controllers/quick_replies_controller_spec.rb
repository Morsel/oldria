require_relative '../spec_helper'
 
describe QuickRepliesController do
  before do
    fake_normal_user
  end
  it "new action should render new template" do
    get :new
    response.should render_template(:new)
  end
end
