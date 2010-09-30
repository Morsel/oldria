require 'spec_helper'

describe AccoladesController do
  integrate_views
  before do
    fake_normal_user
  end

  describe "GET new" do

    describe "for a user accolade" do
      before do
        get :new
      end

      it { assigns[:accoladable].should be_a(Profile) }
      it { response.should be_success }
      it { assigns[:accolade].should be_an(Accolade) }
    end

    describe "for a restaurant accolade" do
      let(:restaurant) { Factory(:restaurant) }

      before do
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
        @profile = Factory(:profile)
        @accolade = Factory(:accolade, :accoladable => @profile)
        Accolade.stubs(:find).returns(@accolade)
        get :edit, :id => @accolade.id
      end

      it { response.should be_success }
      it { assigns[:accolade].should == @accolade }
    end

    describe "for a restaurant accolade" do
      before do
        @profile = Factory(:restaurant)
        @accolade = Factory(:accolade, :accoladable => @profile)
        get :edit, :id => @accolade.id, :restaurant_id => @profile.id
      end

      it { response.should be_success }
      it { assigns[:accolade].should == @accolade }
    end

  end
end
