class RestaurantAnswersController < ApplicationController

  before_filter :require_user
  before_filter :find_and_authorize_restaurant, :except => [:show]

  def show
    @answer = RestaurantAnswer.find(params[:id])
    @question = @answer.restaurant_question
    @other_answers = @question.restaurant_answers.from_premium_restaurants.recently_answered - [@answer]
  end

  def create
     # the form submits a hash of question ids with their answers
    @answer = RestaurantAnswer.new(params[:restaurant_answer])
    @answer.save
    change_post_at_timezone
    flash[:notice] = "Your answers have been saved"
    # respond_to do |wants|
    # wants.js { render :js => render_to_string(:partial => "create")}
    # end
    # render(:layout=>false)
    redirect_to restaurant_social_posts_path(@restaurant)
  end

  def update
    # @answer = RestaurantAnswer.find_by_restaurant_question_id(params[:restaurant_answer][:restaurant_question_id])
    @answer = RestaurantAnswer.find(params[:restaurant_answer][:id])    
    @answer.update_attributes(params[:restaurant_answer])
    change_post_at_timezone
    redirect_to restaurant_social_posts_path(@restaurant)
  end

  
  def destroy
    @answer = RestaurantAnswer.find(params[:id])
    @question = @answer.restaurant_question

    if @answer.destroy
      flash[:notice] = "Your answer has been deleted"
      redirect_to restaurant_questions_path(:restaurant_id => @restaurant.id, 
                                      :chapter_id => @question.chapter.id, 
                                      :anchor => "restaurant_question_#{@question.id}")
    end
  end

  private

  def find_and_authorize_restaurant
    @restaurant = Restaurant.find(params[:restaurant_id])
    unauthorized! unless can? :manage, @restaurant
  end

  def change_post_at_timezone
    i = 0
    if params[:restaurant_answer][:facebook_posts_attributes].present?
      params[:restaurant_answer][:facebook_posts_attributes].each do |facebook_post|
        if facebook_post[1]["post_at"].present?          
          times = time_length(Time.parse(facebook_post[1][:post_at])-Time.zone.now,facebook_post[1][:post_at].split(" ")[1].split(":")[0])
          @answer.facebook_posts[i].update_attributes(:post_at => times)
          i+=1          
        end
      end
    elsif params[:restaurant_answer][:twitter_posts_attributes].present?
      params[:restaurant_answer][:twitter_posts_attributes].each do |twitter_post|
        if twitter_post[1]["post_at"].present?       
          times = time_length(Time.parse(twitter_post[1][:post_at])-Time.zone.now,twitter_post[1][:post_at].split(" ")[1].split(":")[0])
          @answer.twitter_posts[i].update_attributes(:post_at => times)
          i+=1
        end
      end
    end
  end

end
