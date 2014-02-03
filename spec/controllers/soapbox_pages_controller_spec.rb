require_relative '../spec_helper'

describe SoapboxPagesController do

  it "show action should render show template" do
  	soapbox_page = FactoryGirl.create(:soapbox_page)
    get :show,:id=>soapbox_page.id
    response.should render_template(:show)
  end

end
