require_relative '../spec_helper'
 
describe EmploymentSearchesController do
  before(:each) do
    @user = FactoryGirl.create(:admin)
    @user.stubs(:update).returns(true)
    controller.stubs(:current_user).returns(@user)
    controller.stubs(:require_admin).returns(true)
  end

  it "show action should render show template" do
    get :show
    response.should render_template(:partial => 'shared/_employment_list')
  end

end       

 

