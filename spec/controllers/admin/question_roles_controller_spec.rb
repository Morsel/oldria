require_relative '../../spec_helper'

describe Admin::QuestionRolesController do
  integrate_views
  before(:each) do
    fake_admin_user
    FactoryGirl.create(:question_role)
  end

  it "new action should render new template" do
    get :new
    response.should render_template(:new)
  end

  it "create action should render new template when model is invalid" do
    QuestionRole.any_instance.stubs(:valid?).returns(false)
    post :create
    response.should render_template(:action=> "new")
  end

end
