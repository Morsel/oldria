require 'spec_helper'

describe NonculinaryJobsController do
  integrate_views

  before do
    fake_normal_user
  end

  describe "GET 'new'" do
    before do
      get :new
    end

    it { response.should be_success }
    it { assigns[:nonculinary_job].should be_a(NonculinaryJob)}
  end

  describe "GET 'edit'" do
    before do
      NonculinaryJob.stubs(:find).returns(Factory.stub(:nonculinary_job))
      get :edit
    end
    it { response.should be_success }
  end
end
