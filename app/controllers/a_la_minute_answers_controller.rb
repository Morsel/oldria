class ALaMinuteAnswersController < ApplicationController

  before_filter :require_user
  before_filter :require_restaurant_employee, :only => [:destroy, :bulk_edit, :edit, :update, :new, :create,:delete_attachment,:facebook_post]
  before_filter :find_activated_restaurant, :only => [:index]
  before_filter :social_redirect, :only => [:edit]

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
    @answers = @restaurant.a_la_minute_answers.group_by(&:a_la_minute_question_id)
  end

  def new
    @question = ALaMinuteQuestion.find(params[:question_id])
    @answer = ALaMinuteAnswer.new
    @answer.build_social_posts
  end

  def create
    @question = ALaMinuteQuestion.find(params[:question_id])
    @answer = @restaurant.a_la_minute_answers.build(params[:a_la_minute_answer])
    if @answer.save
      flash[:notice] = "Your answer has been created"
      redirect_to :action => "bulk_edit"
    else
      flash[:error] = "Your answer could not be saved. Please review the errors below."
      @answer.build_social_posts
      render :action => "new"
    end
  end

  def edit
    @answer = ALaMinuteAnswer.find(params[:id])
    @answer.build_social_posts
    @question = @answer.a_la_minute_question
  end

  def update
    @answer = ALaMinuteAnswer.find(params[:id])
    @question = @answer.a_la_minute_question

    if @answer.update_attributes(params[:a_la_minute_answer])
      flash[:notice] = "Your answer has been updated"
      redirect_to_social_or 'bulk_edit'
    else
      flash[:error] = "Your answer could not be saved. Please review the errors below."
      @answer.build_social_posts
      render :action => "edit"
    end
  end

  def delete_attachment
    @answer = ALaMinuteAnswer.find(params[:id])
    if params[:type]== "pdf"
      @answer.attachment = nil
    elsif params[:type]== "photo"
       @answer.photo = nil
    end  
    @answer.save
    flash[:notice] = "Deleted attachment"
    redirect_to edit_restaurant_a_la_minute_answer_path(@restaurant,@answer)
  end

  def facebook_post    
    @a_la_minute_answer = @restaurant.a_la_minute_answers.find(params[:id])
    social_post = SocialPost.find(params[:social_id])
    if @a_la_minute_answer.post_to_facebook(social_post.message)
      flash[:notice] = "Posted #{social_post.message} to Facebook page"
    else
      flash[:error] = "Not able to post #{social_post.message} to Facebook page"
    end  
    redirect_to restaurant_social_posts_path(@restaurant)
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

  def social_redirect
    if params[:social]
      session[:redirect_to_social_posts] = restaurant_social_posts_page_path(@restaurant, 'newsfeed')
    end
  end

  def redirect_to_social_or(action)
    redirect_to (session[:redirect_to_social_posts].present?) ? session.delete(:redirect_to_social_posts) : { :action => action }
  end
end