require_relative '../spec_helper'

describe AutoCompleteController do
  include AutoCompleteHelper  
  integrate_views

  describe "GET index" do
    it "Work if get metro in params" do
      get :index,:metro => 'metro'
      xhr :get, 'index'
      response.content_type.should == Mime::JS
    end
    it "Work if get person in params" do
      get :index,:person => 'person'
      xhr :get, 'index'
      response.content_type.should == Mime::JS
    end
    it "Work for else condition" do
      get :index
      xhr :get, 'index'
      response.content_type.should == Mime::JS
    end
  end

  describe "GET auto_complete_keywords" do
    it "Work if get metro in params" do
      @restaurant = FactoryGirl.create(:restaurant)
      get :auto_complete_keywords,:term => "restaurant"     
      expect(response.content_type).to eq("application/json")   
    end
    it "Work for else condition" do
      get :auto_complete_keywords
      expect(response.content_type).to eq("application/json")   
    end
  end

  describe "GET auto_complete_person_keywords" do
    it "Work if get metro in params" do
      @user = FactoryGirl.create(:user)
      get :auto_complete_person_keywords,:term => "foo5"     
      expect(response.content_type).to eq("application/json")   
    end
    it "Work for else condition" do
      get :auto_complete_person_keywords
      expect(response.content_type).to eq("application/json")   
    end
  end  

  describe "GET auto_complete_metropolitan_keywords" do
    it "Work if get metro in params" do
      @metropolitan_area = FactoryGirl.create(:metropolitan_area)
      get :auto_complete_metropolitan_keywords,:term => "Illinois"     
      expect(response.content_type).to eq("application/json")   
    end
    it "Work for else condition" do
      @restaurant = FactoryGirl.create(:restaurant)
      get :auto_complete_metropolitan_keywords
      expect(response.content_type).to eq("application/json")   
    end
  end    

end   