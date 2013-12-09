require_relative '../spec_helper'

describe AccoladesController do
  integrate_views

  describe "GET new" do

    describe "for a user accolade" do
      before do
        fake_normal_user
        @profile = FactoryGirl.create(:profile, :user => @user)
        User.stubs(:find).returns(@user)
        get :new, :user_id => @user.id
      end

      it { assigns[:accoladable].should be_a(Profile) }
      it { response.should be_success }
      it { assigns[:accolade].should be_an(Accolade) }
    end

    describe "for a restaurant accolade" do
      let(:restaurant) { FactoryGirl.create(:restaurant) }

      before do
        fake_admin_user
        get :new, :restaurant_id => restaurant.id
      end

      it { assigns[:accoladable].should be_a(Restaurant) }
      it { response.should be_success }
      it { assigns[:accolade].should be_an(Accolade) }

    end

  end

  describe "GET edit" do
    describe "for a user accolade" do
      before do
        fake_normal_user
        @profile = FactoryGirl.create(:profile)
        @accolade = FactoryGirl.create(:accolade, :accoladable => @profile)
        Accolade.stubs(:find).returns(@accolade)
        get :edit, :id => @accolade.id
      end

      it { response.should be_success }
      it { assigns[:accolade].should == @accolade }
    end

    describe "for a restaurant accolade" do
      before do
        fake_admin_user
        @restaurant = FactoryGirl.create(:restaurant)
        @accolade = FactoryGirl.create(:accolade, :accoladable => @restaurant)
        get :edit, :id => @accolade.id, :restaurant_id => @restaurant.id
      end

      it { response.should be_success }
      it { assigns[:accolade].should == @accolade }
    end

  end

  describe "POST update" do

    it "blocks a user from editing a restaurant they can't edit" do
      fake_normal_user
      @restaurant = FactoryGirl.create(:restaurant)
      @accolade = FactoryGirl.create(:accolade, :accoladable => @restaurant)
      post :update, :id => @accolade.id, :restaurant_id => @restaurant.id,
          :accolade => {:name => "fred"}
      Accolade.find_by_name("fred").should be_nil
      response.should be_redirect
    end

  end

  describe "DELETE destroy" do
    it "blocks a user from deleting a restaurant they can't edit" do
      fake_normal_user
      @restaurant = FactoryGirl.create(:restaurant)
      @accolade = FactoryGirl.create(:accolade, :accoladable => @restaurant, :name => "Top Chef")
      delete :destroy, :id => @accolade.id, :restaurant_id => @restaurant.id
      Accolade.find_by_name("Top Chef").should_not be_nil
      response.should be_redirect
    end
  end

end
