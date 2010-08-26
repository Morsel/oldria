require 'spec_helper'

describe ApprenticeshipsController do

  before(:each) do
    current_user = Factory(:user)
    controller.stubs(:current_user).returns current_user
  end
  
  it "should create a new apprenticeship" do
    profile = Factory(:profile)
    post :create, :profile_id => profile.id, 
        :apprenticeship => { :establishment => "House of Interns", :supervisor => "Captain Crunch", :year => 1980 }
    Apprenticeship.count.should == 1
  end
  
  it "should update a apprenticeship" do
    apprenticeship = Factory(:apprenticeship)
    Apprenticeship.stubs(:find).returns(apprenticeship)
    apprenticeship.expects(:update_attributes).with("supervisor" => "someone else").returns(true)
    put :update, :id => apprenticeship.id, :profile_id => apprenticeship.profile, :apprenticeship => { :supervisor => "someone else" }
  end
  
  it "should destroy a apprenticeship" do
    apprenticeship = Factory(:apprenticeship)
    Apprenticeship.stubs(:find).returns(apprenticeship)
    apprenticeship.expects(:destroy).returns(true)
    delete :destroy, :id => apprenticeship.id, :profile_id => apprenticeship.profile
  end

end
