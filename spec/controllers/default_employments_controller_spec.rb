require_relative '../spec_helper'

describe DefaultEmploymentsController do
  
  before(:each) do
    @user = current_user = FactoryGirl.create(:user)
    controller.stubs(:current_user).returns current_user
  end

  it "should create a new default employment for a user" do
    role = FactoryGirl.create(:restaurant_role)
    subject_matter = FactoryGirl.create(:subject_matter)
    post :create, :user_id => @user.id, 
                  "default_employment" => { "restaurant_role_id" => role.id,
                                            "subject_matter_ids" => [subject_matter.id] }
    @user.reload
    @user.default_employment.should_not be_nil
    @user.primary_employment.should_not be_nil
  end

  it "new action should render new template" do
    get :new
    response.should render_template(:new)
  end


end
