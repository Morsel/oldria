require_relative '../spec_helper'

describe MediaRequestDiscussionsController do

  before(:each) do
    @employee = FactoryGirl.create(:user)
    @recipient = FactoryGirl.create(:employment, :employee => @employee)
    @mrc = FactoryGirl.create(:media_request_discussion, :restaurant => @recipient.restaurant)
    MediaRequestDiscussion.stubs(:find).returns(@mrc)
    @mrc.stubs(:viewable_by?).with(@recipient).returns(true)
    controller.stubs(:current_user).returns(@employee)
  end

  describe "GET show" do
    before do
      get :show, :id => 98
    end
    it { response.should be_success }
    it { assigns[:media_request_discussion].should == @mrc }
  end

  it "Read" do
    post :read
    response.should be_success
  end


end
