require 'spec_helper'

describe CompetitionsController do
  
  before(:each) do
    current_user = Factory(:user)
    controller.stubs(:current_user).returns current_user
  end
  
  it "should create a new competition" do
    profile = Factory(:profile)
    post :create, :profile_id => profile.id, :competition => { :name => "name", :place => "place", :year => 2010 }
    Competition.count.should == 1
  end
  
  it "should update a competition" do
    competition = Factory(:competition)
    Competition.stubs(:find).returns(competition)
    competition.expects(:update_attributes).with("name" => "new name").returns(true)
    put :update, :id => competition.id, :profile_id => competition.profile, :competition => { :name => "new name" }
  end
  
  it "should destroy a competition" do
    competition = Factory(:competition)
    Competition.stubs(:find).returns(competition)
    competition.expects(:destroy).returns(true)
    delete :destroy, :id => competition.id, :profile_id => competition.profile
  end

end
