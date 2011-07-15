class Soapbox::QuestionsController < ApplicationController

  def index
    if params[:user_id]
      @user = User.find(params[:user_id])

      if can? :manage, @user
        @topics = Topic.for_user(@user)
        chapters = @topics.collect do |topic|
          topic.chapters.for_user(@user).all(:limit => 3)
        end
        @chapters_by_topic = chapters.flatten.group_by(&:topic)
      else
        @topics = Topic.answered_for_user(@user)
        chapters = @topics.collect do |topic|
          topic.chapters.answered_for_user(@user).all(:limit => 3)
        end
        @chapters_by_topic = chapters.flatten.group_by(&:topic)
      end

      render :template => 'questions/topics'
    else
      @answers = ProfileQuestion.without_travel.answered_by_premium_users.\
          all(:limit => 10, :order => "profile_answers.created_at DESC").map(&:latest_soapbox_answer).compact.uniq.\
          select { |a| a.user.prefers_publish_profile }
    end
  end

  def show
    @question = ProfileQuestion.find(params[:id])
    @answers = @question.profile_answers.from_premium_users.from_public_users.recently_answered
    @user = User.find(params[:user_id]) if params[:user_id]
    if @user.present?
      @primary_answer = @question.answer_for(@user)
      @answers = @answers - [@primary_answer]
    end
  end

end
