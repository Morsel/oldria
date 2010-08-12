class Admin::TopicsController < ApplicationController
  
  def create
    @topic = Topic.new(params[:topic])
    if @topic.save
      flash[:notice] = "Created new topic named #{@topic.title}"
      redirect_to admin_profile_questions_path
    else
      render :action => "new"
    end
  end
  
  def show
    @topic = Topic.find(params[:id])
  end
  
  def update
    @topic = Topic.find(params[:id])
    @topic.update_attributes(params[:topic])
    flash[:notice] = "Updated topic"
    redirect_to admin_profile_questions_path
  end
  
end
