class Admin::ContentRequestsController < ApplicationController
  def new
    # clean_search_params
    @content_request = Admin::ContentRequest.new
    @search = Employment.search(params[:search])

    if params[:search]
      @employments = @search.all(:select => 'DISTINCT employments.*', :include => [:restaurant])
      @search = Employment.search(nil) # reset the form
    end
  end

  def create
    @content_request = Admin::ContentRequest.new(params[:admin_content_request])
    @search = Employment.search(params[:search])
    if @content_request.save
      flash[:notice] = "Successfully created Question from Oz"
      redirect_to admin_messages_path
    else
      render :new
    end
  end

  def edit
    @content_request = Admin::ContentRequest.find(params[:id])
  end

  def update
    @content_request = Admin::ContentRequest.find(params[:id])
    if @content_request.update_attributes(params[:admin_content_request])
      flash[:notice] = "Successfully updated Question from Oz"
      redirect_to admin_messages_path
    else
      render :edit
    end
  end

  private

  def clean_search_params
    if params[:search] && (namelike = params[:search].delete(:restaurant_name_like))
      params[:search][:restaurant_name_like_all] = namelike.split unless namelike.blank?
    end
  end
end
