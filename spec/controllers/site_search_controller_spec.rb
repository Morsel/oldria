require_relative '../spec_helper'

describe SiteSearchController do

  it "show action should render show template" do
    get :show
    response.should render_template("layouts/application", "soapbox/site_search/show")
  end

end
