class Soapbox::Users::ProfileQuestionsController < ApplicationController

  def index
    @user = User.find(params[:user_id])

    if can? :manage, @user
      @topics = Topic.for_user(@user)
      chapters = @topics.collect do |topic|
        topic.chapters.for_user(@user).all(:limit => 3)
      end
    else
      @topics = Topic.answered_for_user(@user)
      chapters = @topics.collect do |topic|
        topic.chapters.answered_for_user(@user).all(:limit => 3)
      end
    end
    @chapters_by_topic = chapters.flatten.group_by(&:topic)
  end

  def show
    @user = User.find(params[:user_id])
    @question = ProfileQuestion.find(params[:id])
    @answers = @question.profile_answers.from_premium_users.from_public_users.recently_answered

    @primary_answer = @question.answer_for(@user)
    @answers = @answers - [@primary_answer]    
    if @user.completed_setup? && @user.primary_restaurant? && @user.primary_restaurant.premium_account? && @user.linkable_profile?
      primary_restaurant = @user.primary_employment.restaurant
      @menu_items = primary_restaurant.menu_items.all(:order => "created_at DESC",:limit => 3)
      @promotions = primary_restaurant.promotions.all(:limit=>3,:order=>"created_at DESC",:conditions=>["DATE(promotions.start_date) >= DATE(?)", Time.now])
      @user_answers = primary_restaurant.a_la_minute_answers.all(:limit=>3,:order => "a_la_minute_answers.created_at DESC",:conditions=>["DATE(a_la_minute_answers.created_at) = DATE(?)", Time.now])
    end
  end

end
