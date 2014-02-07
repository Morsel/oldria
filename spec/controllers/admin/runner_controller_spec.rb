require_relative '../../spec_helper'

describe Admin::RunnerController do
  integrate_views
  before(:each) do
    fake_admin_user
  end

  it "index" do
    get :index
    response.should be_success
  end
  
end 