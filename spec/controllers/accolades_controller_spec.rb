require 'spec_helper'

describe AccoladesController do
  integrate_views
  before do
    fake_normal_user
  end

  describe "GET new" do
    before do
      get :new
    end

    it { response.should be_success }
    it { assigns[:accolade].should be_an(Accolade) }
  end

  describe "GET edit" do
    before do
      @profile = Factory(:profile)
      @accolade = Factory(:accolade, :profile => @profile)
      Accolade.stubs(:find).returns(@accolade)
      get :edit
    end

    it { response.should be_success }
    it { assigns[:accolade].should == @accolade }
  end
end
