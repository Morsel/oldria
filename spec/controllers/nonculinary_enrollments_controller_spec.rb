require 'spec_helper'

describe NonculinaryEnrollmentsController do
  integrate_views
  before do
    fake_normal_user
  end

  describe "GET 'new'" do
    before do
      get :new
    end

    it { response.should be_success }
    it { assigns[:nonculinary_enrollment].should be_a(NonculinaryEnrollment)}
  end

  describe "GET 'edit'" do
    before do
      NonculinaryEnrollment.stubs(:find).returns(Factory.stub(:nonculinary_enrollment))
      get :edit
    end
    it { response.should be_success }
  end
end
