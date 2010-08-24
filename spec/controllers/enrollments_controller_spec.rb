require 'spec_helper'

describe EnrollmentsController do
  integrate_views
  before do
    fake_normal_user
  end

  describe "GET 'new'" do
    before do
      get :new
    end

    it { response.should be_success }
    it { assigns[:enrollment].should be_an(Enrollment)}
  end

  describe "GET 'edit'" do
    before do
      Enrollment.stubs(:find).returns(Factory.stub(:enrollment))
      get :edit
    end
    it { response.should be_success }
  end
end
