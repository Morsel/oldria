require_relative '../spec_helper'
 
describe AdminMessagesController do
  integrate_views
  before(:each) do
    fake_admin_user
    FactoryGirl.create(:admin_message)
  end

end   
