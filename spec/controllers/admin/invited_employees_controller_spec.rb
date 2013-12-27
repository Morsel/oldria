require_relative '../../spec_helper'
describe Admin::InvitedEmployeesController do

  before(:each) do
    @invited_employee = FactoryGirl.create(:invited_employee)
    @user = FactoryGirl.create(:admin)
    @user.stubs(:update).returns(true)
    controller.stubs(:current_user).returns(@user)
    controller.stubs(:require_admin).returns(true)
  end

   describe "GET index" do
    it "assigns all invited_employee as @invited_employee" do
      InvitedEmployee.stubs(:find).returns([@invited_employee])
      get :index
      assigns[:invited_employees].should == [@invited_employee]
    end
  end

end 	
