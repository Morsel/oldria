require_relative '../../spec_helper'

describe Spoonfeed::ALaMinuteController do
  integrate_views

  before(:each) do
    @user = FactoryGirl.create(:admin)
    @user.stubs(:update).returns(true)
    controller.stubs(:current_user).returns(@user)
    controller.stubs(:require_admin).returns(true)
  end

  describe "GET index" do
    it "assigns all a_la_minuteAnswer as @a_la_minuteAnswer" do
      @answers = ALaMinuteAnswer.from_premium_responders.all(:order => "created_at DESC").paginate(:page =>5)
      get :index
      assigns[:answers].should == @answers
    end
  end

  describe "GET answers" do
    it "assigns all answers as @answers" do
    	@a_la_minute_question = FactoryGirl.create(:a_la_minute_question)
      @answers = @a_la_minute_question.a_la_minute_answers.from_premium_responders.all(:order => "created_at DESC").paginate(:page => 5)
      get :index,:question_id => @a_la_minute_question.id
      assigns[:answers].should == @answers
    end
  end

end
