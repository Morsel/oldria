require_relative '../spec_helper'

describe Spoonfeed::SocialUpdatesController do

  before(:each) do
    @user = Factory.stub(:user)
    controller.stubs(:current_user).returns(@user)

    @restaurant = Factory(:restaurant, :name => "Restaurant 1")
    @restaurant.subscription = Factory(:subscription, :payer => @restaurant)

    @restaurant2 = Factory(:restaurant, :name => "Restaurant 2")
    @restaurant2.subscription = Factory(:subscription, :payer => @restaurant2)

    @alm_answer1 = Factory(:a_la_minute_answer, :responder => @restaurant, :answer => "Answer 1")
    @alm_answer2 = Factory(:a_la_minute_answer, :responder => @restaurant2, :answer => "Answer 2")
    @alm_answer3 = Factory(:a_la_minute_answer, :responder => @restaurant2, :answer => "Answer 3")
  end

  describe "index" do

    it "should display a list of updates" do
      alm_results = [@alm_answer1, @alm_answer2, @alm_answer3].map { |a|
        { :post_data => a.answer,
          :post_id => a.id,
          :restaurant => a.restaurant,
          :post_created_at => a.created_at,
          :link => a.send(:a_la_minute_answers_path, :question_id => a.a_la_minute_question.id),
          :title => a.question,
          :source => "Spoonfeed" }
      }
      alm_results.each { |a| SocialUpdate.create(a) }
      get :index, :page => 1
      assigns[:updates].count.should == 3
    end

  end

  describe "filter" do

    it "should display a filtered list of updates" do
      alm_results = [@alm_answer1].map { |a|
        { :post_data => a.answer,
          :post_id => a.id,
          :restaurant => a.restaurant,
          :post_created_at => a.created_at,
          :link => a.send(:a_la_minute_answers_path, :question_id => a.a_la_minute_question.id),
          :title => a.question,
          :source => "Spoonfeed" }
      }
      alm_results.each { |a| SocialUpdate.create(a) }
      xhr :get, :filter_updates, :search => { :metropolitan_area_id_eq_any => [@restaurant.metropolitan_area.id] }, :page => 1
      assigns[:updates].count.should == 1
    end

  end

end
