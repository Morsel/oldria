require_relative '../spec_helper'

describe ExportPressKitsController do
  before(:each) do
    @user = current_user = FactoryGirl.create(:user)
    controller.stubs(:current_user).returns current_user
  end

  describe "POST create" do
      before { ActionMailer::Base.deliveries = [] }
      user = FactoryGirl.build(:user)
      user.save(:validate => false)  
      restaurant = FactoryGirl.build(:restaurant)
      restaurant.save(:validate => false)  
      it "should send presskit emails" do
        @mailer = stub(:deliver)
        UserMailer.expects(:export_press_kit).once.returns(@mailer)
      end
  end 
end   
