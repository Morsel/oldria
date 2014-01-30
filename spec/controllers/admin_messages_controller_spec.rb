require_relative '../spec_helper'
 
describe AdminMessagesController do
  integrate_views
  before(:each) do
    fake_admin_user
    @admin_message = FactoryGirl.create(:admin_message)
  end

  describe "GET read" do
    it "assigns all admin_message as @admin_message" do
      get :read,:id=>@admin_message.id
      response.body.should == " "
    end
  end



end   
