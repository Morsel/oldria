require 'spec_helper'

describe Spoonfeed::SocialUpdatesController do

  before(:each) do
    @user = Factory.stub(:user)
    controller.stubs(:current_user).returns(@user)

    @restaurant = Factory(:restaurant)
    @restaurant.subscription = Factory(:subscription, :payer => @restaurant)

    @restaurant2 = Factory(:restaurant)
    @restaurant2.subscription = Factory(:subscription, :payer => @restaurant2)

    @alm_answer1 = Factory(:a_la_minute_answer, :responder => @restaurant, :answer => "Answer 1")
    @alm_answer2 = Factory(:a_la_minute_answer, :responder => @restaurant2, :answer => "Answer 2")
    @alm_answer3 = Factory(:a_la_minute_answer, :responder => @restaurant2, :answer => "Answer 3")
  end

  describe "load_updates" do

    it "should display a list of updates" do
      alm_results = [@alm_answer1, @alm_answer2, @alm_answer3].map { |a|
        { :post => a.answer,
          :restaurant => a.restaurant,
          :created_at => a.created_at,
          :link => a_la_minute_answers_path(:question_id => a.a_la_minute_question.id),
          :title => a.question,
          :source => "Spoonfeed" }
      }
      ALaMinuteAnswer.expects(:social_results).with({}).returns(alm_results)
      SocialMerger.expects(:new).returns(mock(:sorted_updates => alm_results))
      xhr :get, :load_updates
      assigns[:updates].count.should == 3
    end

  end

  describe "filter" do

    it "should display a filtered list of updates" do
      alm_results = [@alm_answer1].map { |a|
        { :post => a.answer,
          :restaurant => a.restaurant,
          :created_at => a.created_at,
          :link => a_la_minute_answers_path(:question_id => a.a_la_minute_question.id),
          :title => a.question,
          :source => "Spoonfeed" }
      }
      ALaMinuteAnswer.expects(:social_results).with({ 'metropolitan_area_id_eq_any' => [@restaurant.metropolitan_area.id] }).returns(alm_results)
      SocialMerger.expects(:new).returns(mock(:sorted_updates => alm_results))
      xhr :get, :filter, :search => { :metropolitan_area_id_eq_any => [@restaurant.metropolitan_area.id] }
      assigns[:updates].should == alm_results
    end

  end

end
