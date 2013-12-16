require_relative '../../spec_helper'

describe Spoonfeed::SocialUpdatesController do

  before(:each) do
    @user = FactoryGirl.create(:user)
    controller.stubs(:current_user).returns(@user)

    @restaurant = FactoryGirl.create(:restaurant, :name => "Restaurant 1")
    @restaurant.subscription = FactoryGirl.create(:subscription, :payer => @restaurant)

    @restaurant2 = FactoryGirl.create(:restaurant, :name => "Restaurant 2")
    @restaurant2.subscription = FactoryGirl.create(:subscription, :payer => @restaurant2)

    @alm_answer1 = FactoryGirl.create(:a_la_minute_answer, :responder => @restaurant, :answer => "Answer 1")
    @alm_answer2 = FactoryGirl.create(:a_la_minute_answer, :responder => @restaurant2, :answer => "Answer 2")
    @alm_answer3 = FactoryGirl.create(:a_la_minute_answer, :responder => @restaurant2, :answer => "Answer 3")
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
      assigns[:updates].count.should == 0
    end

  end

end
