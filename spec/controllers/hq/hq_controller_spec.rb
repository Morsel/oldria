require_relative '../../spec_helper'

describe Hq::HqController do
  integrate_views

  it "index action should render index template" do
    get :index
    response.should render_template(:index)
  end
  
end
