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
    
    context "when using an employment search for a group conversation" do
      
      it "should use the search results to select discussion recipients" do
        employments = [Factory(:employment), Factory(:employment)]
        Discussion.any_instance.stubs(:build_employment_search).returns(search = Factory(:employment_search, 
                                                                        :conditions => "--- \n:restaurant_name_like: joe\n")) # fake conditions to match the employment factory data
        post :create, :discussion => { :title => "Hello there" }, :search => {"subject_matters_id_equals_any"=>["1", "3"], "restaurant_james_beard_region_id_equals_any"=>["7", "8"]}        
        Discussion.find_by_title("Hello there").users.count.should == 3
      end
    end
  end
end
