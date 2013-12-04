require_relative '../spec_helper'

describe StagesController do

  before(:each) do
    current_user = Factory(:user)
    controller.stubs(:current_user).returns current_user
    @profile = Factory(:profile, :user => current_user)
  end
  
  it "should create a new stage" do
    post :create, :profile_id => @profile.id, 
        :stage => { :establishment => "House of Experts", :expert => "Top Expert", :start_date => 2.years.ago }
    Stage.count.should == 1
  end
  
  it "should update a stage" do
    stage = Factory(:stage)
    Stage.stubs(:find).returns(stage)
    stage.expects(:update_attributes).with("expert" => "Another Expert").returns(true)
    put :update, :id => stage.id, :profile_id => stage.profile, :stage => { :expert => "Another Expert" }
  end
  
  it "should destroy a stage" do
    stage = Factory(:stage)
    Stage.stubs(:find).returns(stage)
    stage.expects(:destroy).returns(true)
    delete :destroy, :id => stage.id, :profile_id => stage.profile
  end

end
