class Admin::TopicsController < ApplicationController
  
  def index
    @topics = Topic.all
  end
  
  def create
    @topic = Topic.new(params[:topic])
    if @topic.save
      flash[:notice] = "Created new topic named #{@topic.title}"
      redirect_to admin_profile_questions_path
    else
      render :action => "show"
    end
  end
  
  def show
    @topic = Topic.find(params[:id])
  end
  
  def edit
    redirect_to :action => "show", :id => params[:id]
  end
  
  def update
    @topic = Topic.find(params[:id])
    @topic.update_attributes(params[:topic])
    flash[:notice] = "Updated topic"
    redirect_to admin_profile_questions_path
  end
  
  def destroy
    @topic = Topic.find(params[:id])
    if @topic.chapters.count > 0
      flash[:error] = "Unable to delete topics currently assigned to chapters"
    else
      flash[:notice] = "Deleted topic #{@topic.title}"
      @topic.destroy
    end
    redirect_to :action => "index"
  end
  
end
