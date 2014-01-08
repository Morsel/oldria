class StatusesController < ApplicationController
  before_filter :require_user
  before_filter :require_owner, :except => [:index, :destroy]

  def index
    @user = User.find(params[:user_id])
    @statuses = @user.first.statuses.paginate(:page => params[:page], :per_page => 10)
    @editable = (@user == current_user)
  end

  def create
    @status = @user.statuses.build(params[:status])
    if @status.save
      flash[:notice] = "Successfully created status."
      respond_to do |format|
        format.html { redirect_to user_statuses_path(@user) }
        format.js
      end
    else
      render :new
    end
  end

  def destroy
    @status = current_user.statuses.find(params[:id])
    @status.destroy
    flash[:notice] = "Successfully destroyed status."
    respond_to do |format|
      format.html { redirect_to user_statuses_path(@user) }
      format.js
    end
  end

  private

  def require_owner
    @user = User.find(params[:user_id])
    unless @user == current_user
      flash[:notice] = "You are not authorized to edit this"
      redirect_to root_url
    end
  end

end
