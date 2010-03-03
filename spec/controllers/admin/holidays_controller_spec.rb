require 'spec/spec_helper'

describe Admin::HolidaysController do
  integrate_views
  before(:each) do
    fake_admin_user
    Holiday.create!(:name => "Easter")
  end

  it "index action should render index template" do
    get :index
    response.should render_template(:index)
  end

  it "show action should render show template" do
    get :show, :id => Holiday.first
    response.should render_template(:show)
  end

  it "new action should render new template" do
    get :new
    response.should render_template(:new)
  end

  it "create action should render new template when model is invalid" do
    Holiday.any_instance.stubs(:valid?).returns(false)
    post :create
    response.should render_template(:new)
  end

  it "create action should redirect when model is valid" do
    Holiday.any_instance.stubs(:valid?).returns(true)
    post :create
    response.should redirect_to(admin_holidays_path)
  end

  it "edit action should render edit template" do
    get :edit, :id => Holiday.first
    response.should render_template(:edit)
  end

  it "update action should render edit template when model is invalid" do
    Holiday.any_instance.stubs(:valid?).returns(false)
    put :update, :id => Holiday.first
    response.should render_template(:edit)
  end

  it "update action should redirect when model is valid" do
    Holiday.any_instance.stubs(:valid?).returns(true)
    put :update, :id => Holiday.first
    response.should redirect_to(admin_holidays_path)
  end

  it "destroy action should destroy model and redirect to index action" do
    holiday = Holiday.first
    delete :destroy, :id => holiday
    response.should redirect_to(admin_holidays_path)
    Holiday.exists?(holiday.id).should be_false
  end
end
