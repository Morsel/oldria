require 'spec_helper'

describe AwardsController do
  integrate_views
  before do
    fake_normal_user
  end

  describe "GET 'new'" do
    before do
      get :new
    end

    it { response.should be_success }
    it { assigns[:award].should be_an(Award)}
  end

  describe "GET 'edit'" do
    before do
      Award.stubs(:find).returns(Factory.stub(:award))
      get :edit
    end
    it { response.should be_success }
  end
end
