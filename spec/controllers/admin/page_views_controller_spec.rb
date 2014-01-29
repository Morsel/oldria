require_relative '../../spec_helper'

describe Admin::PageViewsController do
  integrate_views

  before(:each) do
    @page_view = FactoryGirl.create(:page_view)
    @soapbox_trace_keyword = FactoryGirl.create(:soapbox_trace_keyword)
    @user = FactoryGirl.create(:admin)
    @user.stubs(:update).returns(true)
    controller.stubs(:current_user).returns(@user)
    controller.stubs(:require_admin).returns(true)
  end

  describe "GET index" do
    it "assigns all page_views as @page_views" do
      PageView.stubs(:find).returns([@page_view])
      get :index
      assigns[:page_views].should == [@page_view]
    end
  end

  describe "GET trace_keyword_for_soapbox" do
    it "assigns all trace_keyword_for_soapbox as @trace_keyword_for_soapbox" do
      SoapboxTraceKeyword.stubs(:find).returns([@soapbox_trace_keyword])
      get :trace_keyword_for_soapbox
      assigns[:soapbox_trace_keywords].should == [@soapbox_trace_keyword]
    end
  end

end
