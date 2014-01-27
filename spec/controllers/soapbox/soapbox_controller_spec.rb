require_relative '../../spec_helper'

describe Soapbox::SoapboxController do

  describe "GET index" do
    it "get index page for if condition" do
    	request.accept = "application/json"
      get :index,:name=>"test"
      response.header['Content-Type'].should include 'application/json'
    end
    it "get index page for else condition" do
      get :index
      response.should render_template("layouts/soapbox_home", "index")
    end
  end

  describe "GET directory" do
    it " if get specialty_id" do
    	@specialty = FactoryGirl.create(:specialty)
      get :directory,:specialty_id=>@specialty.id
      @users = User.in_soapbox_directory.search(:profile_specialties_id_equals => @specialty.id).all(:order => "users.last_name").uniq
      assigns[:users].should == @users
    end

    it "if get cuisine_id" do
    	@cuisine = FactoryGirl.create(:cuisine)
      get :directory,:cuisine_id=>@cuisine.id
      @users = User.in_soapbox_directory.search(:profile_specialties_id_equals => @cuisine.id).all(:order => "users.last_name").uniq
      assigns[:users].should == @users
    end

    it "Work for else condition will get all users" do
      get :directory
      @users = User.in_soapbox_directory.all(:order => "users.last_name")
      assigns[:users].should == @users
    end

    it "for render_template" do
      get :directory
      response.should render_template("directory/index")
    end
  end

  describe "GET directory_search" do
    it "get directory_search should render search_results" do
      get :directory_search
      response.should render_template("directory/_search_results")
    end
  end
 
  describe "GET restaurant_directory" do
    it " if get metropolitan_area_id" do
    	@metropolitan_area = FactoryGirl.create(:metropolitan_area)
      get :restaurant_directory,:metropolitan_area_id=>@metropolitan_area.id
      @restaurants = Restaurant.search(:metropolitan_area_id_equals => @metropolitan_area.id).all.uniq
      assigns[:restaurants].should == @restaurants
    end

    it "if get cuisine_id" do
    	@cuisine = FactoryGirl.create(:cuisine)
      get :restaurant_directory,:cuisine_id=>@cuisine.id
      @restaurants = Restaurant.search(:cuisine_id_equals =>@cuisine.id).all.uniq
      assigns[:restaurants].should == @restaurants
    end

    it "if get james_beard_region_id" do
    	@james_beard_region = FactoryGirl.create(:james_beard_region)
      get :restaurant_directory,:james_beard_region_id=>@james_beard_region.id
       @restaurants = Restaurant.search(:james_beard_region_id_equals => @james_beard_region.id).all.uniq
      assigns[:restaurants].should == @restaurants
    end

    it "for render_template" do
      get :restaurant_directory
      response.should render_template("directory/restaurants")
    end
  end

  describe "GET restaurant_search" do
    it "get restaurant_search should render restaurant_search" do
      get :restaurant_search
      response.should render_template("directory/_restaurant_search_results")
    end
  end

  describe "GET travel_guides" do
    it "get travel_guides " do
    	@topic = FactoryGirl.create(:topic, :title => "Travel Guide")
      get :travel_guides
      response.should redirect_to(soapbox_btl_topic_path(Topic.travel))
    end
  end

  describe "GET auto_complete_keywords" do
    it "get auto_complete_keywords " do
      request.accept = "application/json"
      get :auto_complete_keywords
      response.header['Content-Type'].should include 'application/json'
    end
  end

end
