require_relative '../../spec_helper'

describe Soapbox::SiteSearchController do

  describe "search for QOTDs and Trend questions and comments" do
    it "should find trend question" do
      entry = FactoryGirl.create(:soapbox_entry, :featured_item => FactoryGirl.create(:trend_question))
      get :show, :query => entry.featured_item.subject
      assigns[:trend_questions_found].should == [entry.featured_item]
    end

    it "should find question of the day" do
      entry = FactoryGirl.create(:soapbox_entry)
      entry.reload
      entry.update_attributes("featured_item_type" => "Admin::Qotd")
      get :show, :query => "question"
      assigns[:qotds_found].should == [entry.featured_item]
    end
  end

  describe "search for btl questions and comments" do
    before(:each) do
      @profile_user = FactoryGirl.create(:published_user, :subscription => FactoryGirl.create(:subscription))
      role = FactoryGirl.create(:restaurant_role)
      @profile_user.stubs(:primary_employment).returns(FactoryGirl.create(:employment, :restaurant_role => role, :employee => @profile_user))
      @question = FactoryGirl.create(:profile_question)
      @answer = FactoryGirl.create(:profile_answer, :profile_question => @question, :user => @profile_user)
    end

    it "should find question" do
      get :show, :query => @question.title
      assigns[:btl_questions_found].should == [@question]
    end

    it "should find question answer" do
      get :show, :query => @answer.answer
      assigns[:btl_answers_found].should == [@answer]
    end
  end

  describe "search users" do
    it "Should find one user" do
      user = FactoryGirl.create(:published_real_user_with_subscription)
      user.publish_profile = true
      FactoryGirl.create(:profile, :summary => "The toys", :user => user)
      get :show, :query => "toys"
      assigns[:users_found].should == [user]
    end
  end

end
