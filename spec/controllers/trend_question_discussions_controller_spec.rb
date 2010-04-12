require 'spec/spec_helper'

describe TrendQuestionDiscussionsController do
  integrate_views
  before do
    fake_normal_user
    @restaurant = Factory(:restaurant)
    @trend_question = Factory(:trend_question)
    @trend_question_discussion = TrendQuestionDiscussion.create!(:restaurant => @restaurant, :trend_question => @trend_question)
  end

  describe "GET 'show'" do
    before do
      get :show, :id => @trend_question_discussion.id
    end
    it { response.should be_success }
    it { assigns[:trend_question].should == @trend_question }
  end
end
