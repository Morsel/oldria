require_relative '../spec_helper'

describe DefaultEmploymentsController do
  
  before(:each) do
    @user = current_user = Factory(:user)
    controller.stubs(:current_user).returns current_user
  end

  it "should create a new default employment for a user" do
    role = Factory(:restaurant_role)
    subject_matter = Factory(:subject_matter)
    post :create, :user_id => @user.id, 
                  "default_employment" => { "restaurant_role_id" => role.id,
                                            "subject_matter_ids" => [subject_matter.id] }
    @user.reload
    @user.default_employment.should_not be_nil
    @user.primary_employment.should_not be_nil
  end

end
