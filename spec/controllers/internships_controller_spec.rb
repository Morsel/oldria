require 'spec_helper'

describe InternshipsController do

  before(:each) do
    current_user = Factory(:user)
    controller.stubs(:current_user).returns current_user
  end
  
  it "should create a new internship" do
    profile = Factory(:profile)
    post :create, :profile_id => profile.id, 
        :internship => { :establishment => "House of Interns", :supervisor => "Captain Crunch", :start_date => 1.year.ago, :end_date => 10.months.ago }
    Internship.count.should == 1
  end
  
  it "should update a internship" do
    internship = Factory(:internship)
    Internship.stubs(:find).returns(internship)
    internship.expects(:update_attributes).with("supervisor" => "someone else").returns(true)
    put :update, :id => internship.id, :profile_id => internship.profile, :internship => { :supervisor => "someone else" }
  end
  
  it "should destroy a internship" do
    internship = Factory(:internship)
    Internship.stubs(:find).returns(internship)
    internship.expects(:destroy).returns(true)
    delete :destroy, :id => internship.id, :profile_id => internship.profile
  end

end
