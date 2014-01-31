require_relative '../spec_helper'

describe DirectoryController do

  before(:each) do
    current_user = FactoryGirl.create(:user)
    controller.stubs(:current_user).returns(current_user)
    FactoryGirl.create(:published_user); FactoryGirl.create(:published_user)
    FactoryGirl.create(:restaurant); FactoryGirl.create(:restaurant)
  end

  describe "GET index" do
    it "Work for index method if get specialty_id in params" do
      specialty = FactoryGirl.create(:specialty)
      get :index,:specialty_id=>specialty.id
      users = User.in_soapbox_directory.search(:profile_specialties_id_equals => specialty.id).all(:order => "users.last_name").uniq
      assigns[:users].should == users
    end
    it "Work for index method if get cuisine_id in params" do
      cuisine = FactoryGirl.create(:cuisine)
      get :index,:cuisine_id=>cuisine.id
      users = User.in_soapbox_directory.search(:profile_cuisines_id_equals => cuisine.id).all(:order => "users.last_name").uniq
      assigns[:users].should == users
    end
    it "Work for index method if get metropolitan_area in params" do
      metropolitan_area = FactoryGirl.create(:metropolitan_area)
      get :index,:cuisine_id=>metropolitan_area.id
      users = User.in_soapbox_directory.search(:profile_metropolitan_area_id_equals => metropolitan_area.id).all(:order => "users.last_name").uniq
      assigns[:users].should == users
    end
    it "Work for index method if get james_beard_region_id in params" do
      james_beard_region = FactoryGirl.create(:james_beard_region)
      get :index,:james_beard_region_id=>james_beard_region.id
      users = User.in_soapbox_directory.search(:profile_james_beard_region_id_equals => james_beard_region.id).all(:order => "users.last_name").uniq
      assigns[:users].should == users
    end
  end

  describe "GET search" do
    it "Work for search condition" do
      get :search
      response.should render_template(:partial => 'directory/_search_results')
    end
  end

  describe "GET restaurants" do
    it "Work for index method if get cuisine_id in params" do
      cuisine = FactoryGirl.create(:cuisine)
      get :restaurants,:cuisine_id=>cuisine.id
      restaurants = Restaurant.activated_restaurant.search(:cuisine_id_eq => cuisine.id).all.uniq
      assigns[:restaurants].should == restaurants
    end
    it "Work for index method if get metropolitan_area_id in params" do
      metropolitan_area = FactoryGirl.create(:metropolitan_area)
      get :restaurants,:metropolitan_area_id=>metropolitan_area.id
      restaurants = Restaurant.activated_restaurant.search(:metropolitan_area_id_equals => metropolitan_area.id).all.uniq
      assigns[:restaurants].should == restaurants
    end
    it "Work for index method if get james_beard_region_id in params" do
      james_beard_region = FactoryGirl.create(:james_beard_region)
      get :restaurants,:james_beard_region_id=>james_beard_region.id
      restaurants = Restaurant.activated_restaurant.search(:james_beard_region_id_equals => james_beard_region.id).all.uniq
      assigns[:restaurants].should == restaurants
    end
  end

  describe "GET restaurant_search" do
    it "Work for restaurant_search" do
      get :restaurant_search
      response.should render_template(:partial => 'directory/_restaurant_search_results')
    end
  end

  describe "GET current_user_restaurants" do
    it "Work for current_user_restaurants" do
      get :current_user_restaurants
      expect { get :current_user_restaurants }.to_not render_template(layout: "application")
    end
  end

  describe "GET get_restaurant_url" do
    it "Work for get_restaurant_url" do
      restaurant = FactoryGirl.create(:restaurant)
      get :get_restaurant_url,:restaurant_id=>restaurant.id,:clicked_page=>"test"
      response.header['Content-Type'].should include 'application/json'
    end
  end


end