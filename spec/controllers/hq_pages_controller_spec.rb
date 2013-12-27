require_relative '../spec_helper'
 
describe HqPagesController do
   
  describe "GET #show" do
    it "assigns the requested page to @page" do
      hq_page = FactoryGirl.create(:hq_page)
      get :show, id: hq_page
      assigns(:page).should eq(hq_page)
    end
    
    it "renders the #show view" do
      get :show, id: FactoryGirl.create(:hq_page) 
        should render_with_layout('hq')  
        response.should render_template :show
    end 
  end    

 
end
