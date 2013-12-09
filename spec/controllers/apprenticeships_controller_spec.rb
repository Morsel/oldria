require_relative '../spec_helper'

describe ApprenticeshipsController do

  before(:each) do
    @user = FactoryGirl.create(:user)
    controller.stubs(:current_user).returns @user
    @profile = FactoryGirl.create(:profile, :user => @user)
    User.stubs(:find).returns(@user)
  end
  
  it "should create a new apprenticeship" do
    post :create, :user_id => @user.id, 
        :apprenticeship => { :establishment => "House of Interns", :supervisor => "Captain Crunch", :year => 1980,:start_date =>Time.now }
    # debugger
    Apprenticeship.count.should == 1
  end
  
  it "should update a apprenticeship" do
    apprenticeship = FactoryGirl.create(:apprenticeship)
    Apprenticeship.stubs(:find).returns(apprenticeship)
    apprenticeship.expects(:update_attributes).with("supervisor" => "someone else").returns(true)
    put :update, :id => apprenticeship.id, :profile_id => apprenticeship.profile, :apprenticeship => { :supervisor => "someone else" }
  end
  
  it "should destroy a apprenticeship" do
    apprenticeship = FactoryGirl.create(:apprenticeship)
    Apprenticeship.stubs(:find).returns(apprenticeship)
    apprenticeship.expects(:destroy).returns(true)
    delete :destroy, :id => apprenticeship.id, :profile_id => apprenticeship.profile
  end

end
