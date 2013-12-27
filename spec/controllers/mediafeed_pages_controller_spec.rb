require_relative '../spec_helper'
 
describe MediafeedPagesController do
   
  describe "GET #show" do
    it "assigns the requested page to @page" do
      mediafeed_page = FactoryGirl.create(:mediafeed_page)
      get :show, id: mediafeed_page
      assigns(:page).should eq(mediafeed_page)
    end
    
    it "renders the #show view" do
      get :show, id: FactoryGirl.create(:mediafeed_page) 
      response.should render_template :show
    end 
  end    

 
end
