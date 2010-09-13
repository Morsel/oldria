require 'spec_helper'

describe CulinaryJobsController do
  integrate_views

  before do
    fake_normal_user
  end

  describe "GET 'new'" do
    before do
      get :new
    end

    it { response.should be_success }
    it { assigns[:culinary_job].should be_a(CulinaryJob)}
  end

  describe "GET 'edit'" do
    before do
      CulinaryJob.stubs(:find).returns(Factory.stub(:culinary_job))
      get :edit
    end
    it { response.should be_success }
  end
end
