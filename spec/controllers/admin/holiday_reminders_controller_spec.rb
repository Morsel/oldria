require_relative '../../spec_helper'

describe Admin::HolidayRemindersController do

  integrate_views

  before(:each) do
    @holiday = FactoryGirl.create(:holiday)
    @holiday_reminder = FactoryGirl.create(:holiday_reminder, :holiday => @holiday)
    @user = FactoryGirl.create(:admin)
    @user.stubs(:update).returns(true)
    controller.stubs(:current_user).returns(@user)
    controller.stubs(:require_admin).returns(true)
  end

  describe "GET new" do
    it "assigns a new holiday_reminder as @holiday_reminder" do
      Admin::HolidayReminder.stubs(:new).returns(@holiday_reminder)
      get :new
      assigns[:holiday_reminder].should equal(@holiday_reminder)
      response.should render_template(:new)
    end
  end

  describe "POST create" do

    describe "with valid params" do
      before(:each) do
        Admin::HolidayReminder.stubs(:new).returns(@holiday_reminder)
        Admin::HolidayReminder.any_instance.stubs(:save).returns(true)
      end

      it "assigns a newly created holiday_reminder as @holiday_reminder" do
        post :create, :holiday_reminder => {}
        assigns[:holiday_reminder].should equal(@holiday_reminder)
      end

      it "redirects to the created holiday_reminder" do
        post :create, :holiday_reminder => {}
        response.should redirect_to((@holiday_reminder.holiday ? [:admin, @holiday_reminder.holiday] : admin_messages_path))
      end
    end
    describe "with invalid params" do
      before(:each) do
        Admin::HolidayReminder.any_instance.stubs(:save).returns(false)
        Admin::HolidayReminder.stubs(:new).returns(@holiday_reminder)
      end

      it "assigns a newly created but unsaved holiday_reminder as @holiday_reminder" do
        post :create, :holiday_reminder => {:these => 'params'}
        assigns[:holiday_reminder].should equal(@holiday_reminder)
      end

      it "re-renders the 'new' template" do
        post :create, :holiday_reminder => {}
        response.should render_template(:action=> "new")
      end
    end
  end

  describe "GET edit" do
    it "assigns the requested holiday_reminder as @holiday_reminder" do
      Admin::HolidayReminder.stubs(:find).returns(@holiday_reminder)
      get :edit, :id => "37"
      assigns[:holiday_reminder].should equal(@holiday_reminder)
    end
  end

 describe "PUT update" do

    describe "with valid params" do
      before(:each) do
        Admin::HolidayReminder.stubs(:find).returns(@holiday_reminder)
        Admin::HolidayReminder.any_instance.stubs(:update_attributes).returns(true)
      end

      it "updates the requested holiday_reminder" do
        Admin::HolidayReminder.expects(:find).with("37").returns(@holiday_reminder)
        put :update, :id => "37", :holiday_reminder => {:these => 'params'}
      end

      it "assigns the requested holiday_reminder as @holiday_reminder" do
        Admin::HolidayReminder.stubs(:find).returns(@holiday_reminder)
        put :update, :id => "1"
        assigns[:holiday_reminder].should equal(@holiday_reminder)
      end

      it "redirects to all holiday_reminder" do
        Admin::HolidayReminder.stubs(:find).returns(@holiday_reminder)
        put :update, :id => "1"
        response.should redirect_to (@holiday_reminder.holiday ? [:admin, @holiday_reminder.holiday] : admin_messages_path)
      end
    end

    describe "with invalid params" do
      before(:each) do
        Admin::HolidayReminder.stubs(:find).returns(@holiday_reminder)
        Admin::HolidayReminder.any_instance.stubs(:update_attributes).returns(false)
      end

      it "updates the requested holiday_reminder" do
        Admin::HolidayReminder.expects(:find).with("37").returns(@holiday_reminder)
        put :update, :id => "37", :holiday_reminder => {:these => 'params'}
      end

      it "assigns the holiday_reminder as @holiday_reminder" do
        put :update, :id => "1"
        assigns[:holiday_reminder].should equal(@holiday_reminder)
      end

      it "re-renders the 'edit' template" do
        Admin::HolidayReminder.stubs(:find).returns(@holiday_reminder)
        put :update, :id => "1"
        response.should render_template(:action=> "edit")
      end
    end
  end

end 


