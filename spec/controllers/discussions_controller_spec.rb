require_relative '../spec_helper'

describe DiscussionsController do
  integrate_views

  before do
    @user = FactoryGirl.create(:user)
    controller.stubs(:current_user).returns(@user)
  end

  describe "GET 'show'" do
    before do
      @discussion = FactoryGirl.create(:discussion, :poster => @user)
      get :show, :id => @discussion.id
    end

    it { response.should be_success }
    it { assigns[:discussion].should == @discussion }
    it { assigns[:comment].should be_a(Comment) }
   end

  describe "GET new" do
    before do
      @employment = FactoryGirl.create(:employment, :employee => @user)
      @user.stubs(:messages_from_ria).returns([])
      get :new
    end

    it { response.should be_success }
    it { assigns[:discussion].poster_id.should eql(@user.id) }
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
        @discussion = FactoryGirl.create(:discussion)
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
