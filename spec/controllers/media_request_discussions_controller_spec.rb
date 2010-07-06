require 'spec/spec_helper'

describe MediaRequestDiscussionsController do
  integrate_views

  before(:each) do
    @employee = Factory(:user)
    @employee.stubs(:update).returns(true)
    @recipient = Factory(:employment, :employee => @employee)
    @mrc = Factory(:media_request_discussion, :restaurant => @recipient.restaurant)
    MediaRequestDiscussion.stubs(:find).returns(@mrc)
    controller.stubs(:current_user).returns(@employee)
  end

  describe "GET show" do
    before do
      get :show, :id => 98
    end
    it { response.should be_success }
    it { assigns[:media_request_discussion].should == @mrc }
      
  end
end
