require_relative '../spec_helper'

describe JoinController do

  describe "GET 'index'" do
    it "should be successful" do
      get 'index'
      response.should be_success
    end
  end

  describe "registration" do

    it "should sign up a new media user" do
      User.expects(:build_media_from_registration).returns(FactoryGirl.build(:media_user))
      post :register, :first_name => "Media", :last => "User", :email => "myemail@newspaper.com", :role => "media"
    end

    it "should sign up a new restaurant user" do
      Invitation.expects(:build_from_registration).returns(FactoryGirl.build(:invitation))
      post :register, :first_name => "Restaurant", :last => "User", :email => "myemail@restaurant.com", :role => "restaurant"
    end

    it "should sign up a new diner (newsletter) user" do
      NewsletterSubscriber.expects(:build_from_registration).returns(FactoryGirl.build(:newsletter_subscriber))
      post :register, :first_name => "Foodie", :last => "User", :email => "myemail@foodglutton.com", :role => "diner"
    end

  end

  describe "soapbox_register" do
    it "Work if get media role on params" do
      User.expects(:build_media_from_registration).returns(FactoryGirl.build(:media_user))
      post :soapbox_register, :first_name => "Media", :last => "User", :email => "myemail@newspaper.com", :role => "media"
   end
    it "Work if get restaurant role on params" do
      Invitation.expects(:build_from_registration).returns(FactoryGirl.build(:invitation))
      post :soapbox_register, :first_name => "Restaurant", :last => "User", :email => "myemail@restaurant.com", :role => "restaurant"
   end
    it "should sign up a new diner (newsletter) user" do
      NewsletterSubscriber.expects(:build_from_registration).returns(FactoryGirl.build(:newsletter_subscriber))
      post :soapbox_register, :first_name => "Foodie", :last => "User", :email => "myemail@foodglutton.com", :role => "diner"
    end
  end

  describe "soapbox_join" do
    it "Work if get media role on params" do
      post :soapbox_join
      response.should be_success
    end
  end


end 