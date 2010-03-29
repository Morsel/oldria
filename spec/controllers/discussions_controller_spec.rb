require 'spec/spec_helper'

describe DiscussionsController do
  integrate_views

  before do
    @user = Factory(:user)
    controller.stubs(:current_user).returns(@user)
  end

  describe "GET 'show'" do
    before do
      @discussion = Factory(:discussion, :poster => @user)
      get :show, :id => @discussion.id
    end

    it { response.should be_success }
    it { assigns[:discussion].should == @discussion }
    it { assigns[:comment].should be_a(Comment) }
   end

  describe "GET new" do
    before do
      @employment = Factory.stub(:employment)
      Employment.stubs(:find).returns(@employment)
      get :new
    end

    it { response.should be_success }
    it { assigns[:discussion].poster.should eql(@user) }
  end

  describe "POST create" do
    context "association to user who posts it" do
      before do
        post :create, :discussion => {}
      end

      it { assigns[:discussion].poster.should eql(@user) }
    end

    context "when discussion is valid" do
      before do
        @discussion = Factory(:discussion)
        Discussion.expects(:new).returns(@discussion)
        @discussion.stubs(:save).returns(@discussion)
        post :create, :discussion => {}
      end

      it { response.should redirect_to(discussion_path(@discussion)) }
    end

    context "when discussion is valid" do
      before do
        Discussion.any_instance.expects(:valid?).returns(false)
        post :create, :discussion => {}
      end

      it { response.should render_template(:new) }
    end
  end
end
