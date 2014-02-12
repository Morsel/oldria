require_relative '../spec_helper'

describe CompetitionsController do
  
  before(:each) do
    @user = FactoryGirl.create(:user)
    controller.stubs(:current_user).returns @user
    @profile = FactoryGirl.create(:profile, :user => @user)
    User.stubs(:find).returns(@user)
  end
  
  it "should create a new competition" do
    post :create, :user_id => @user.id, :competition => { :name => "name", :place => "place", :year => 2010 }
    Competition.count.should == 1
  end
  
  it "should update a competition" do
    competition = FactoryGirl.create(:competition)
    Competition.stubs(:find).returns(competition)
    competition.expects(:update_attributes).with("name" => "new name").returns(true)
    put :update, :id => competition.id, :profile_id => competition.profile, :competition => { :name => "new name" }
  end
  
  it "should destroy a competition" do
    competition = FactoryGirl.create(:competition)
    Competition.stubs(:find).returns(competition)
    competition.expects(:destroy).returns(true)
    delete :destroy, :id => competition.id, :profile_id => competition.profile
  end

  it "edit action should render edit template" do
    get :edit, :id => Competition.first
    response.should be_success
  end

  it "create action should render new template when model is invalid" do
    Competition.any_instance.stubs(:valid?).returns(false)
    post :create
    response.should be_success
  end
end
