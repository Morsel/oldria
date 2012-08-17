class ALaMinuteAnswersController < ApplicationController

  before_filter :require_user
  before_filter :require_restaurant_employee, :only => [:destroy, :bulk_edit, :bulk_update]
  before_filter :find_activated_restaurant, :only=>[:index]

  def index    
    @questions = ALaMinuteAnswer.public_profile_for(@restaurant)
  end

  def destroy
    @restaurant.a_la_minute_answers.destroy(params[:id])

    if request.xhr?
      render :nothing => true
    else
      flash[:success] = "Answer removed."
      redirect_to :action => :bulk_edit
    end
  end

  def bulk_edit
    @questions = ALaMinuteQuestion.restaurants
  end

  def bulk_update
    params[:a_la_minute_questions].each do |id, attributes|
      question = ALaMinuteQuestion.find(id)
      answer_id = attributes.delete(:answer_id)
      previous_answer = ALaMinuteAnswer.find(answer_id) if ALaMinuteAnswer.exists?(answer_id)

      # create a new answer if the answer has changed
      unless attributes[:answer] == previous_answer.try(:answer)
        attributes[:post_to_twitter_at] = Time.parse("#{attributes[:post_to_twitter_at][:year]}-#{attributes[:post_to_twitter_at][:month]}-#{attributes[:post_to_twitter_at][:day]} #{attributes[:post_to_twitter_at][:hour]}:#{attributes[:post_to_twitter_at][:minute]}") if attributes[:post_to_twitter_at].present?
        attributes[:post_to_facebook_at] = Time.parse("#{attributes[:post_to_facebook_at][:year]}-#{attributes[:post_to_facebook_at][:month]}-#{attributes[:post_to_facebook_at][:day]} #{attributes[:post_to_facebook_at][:hour]}:#{attributes[:post_to_facebook_at][:minute]}") if attributes[:post_to_facebook_at].present?

        new_answer = @restaurant.a_la_minute_answers.create(attributes.merge(:a_la_minute_question_id => id))
      end

      flash[:success] = "Your changes have been saved."
    end
    redirect_to :action => :bulk_edit
  end

  private

  def require_restaurant_employee
    @restaurant = Restaurant.find(params[:restaurant_id])
    unless @restaurant.employees.include?(current_user) || current_user.admin?
      flash[:notice] = "You must be an employee of #{@restaurant.name} to answer and edit questions"
      redirect_to restaurants_url and return
    end
    true
  end
  def find_activated_restaurant      
      @restaurant = Restaurant.find(params[:restaurant_id])
      unless @restaurant.is_activated?        
        flash[:error] = "This restaurant is not activated."
        redirect_to :restaurants
      end
  end  
end
