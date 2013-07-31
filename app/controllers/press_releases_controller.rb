class PressReleasesController < ApplicationController

  before_filter :find_restaurant
  before_filter :require_manager, :except => [:archive]
  before_filter :check_employments, :only => [:index]

  def index
    @press_release = @restaurant.press_releases.build
    @press_release.pdf_remote_attachment = PdfRemoteAttachment.new
  end

  def create
    @press_release = @restaurant.press_releases.build(params[:press_release])
    if @press_release.save
      flash[:notice] = "Your press release has been saved"
      redirect_to :action => "index", :restaurant_id => @restaurant.id
    else
      flash[:error] = @press_release.errors.full_messages.to_sentence
      render :action => "edit"
    end
  end

  def edit
    @press_release = PressRelease.find(params[:id])
  end

  def update
    @press_release = PressRelease.find(params[:id])
    if @press_release.update_attributes(params[:press_release])
      flash[:notice] = "Your press release has been saved"
      redirect_to :action => "index", :restaurant_id => @restaurant.id
    else
      render :action => "edit"
    end
  end

  def destroy
    @press_release = PressRelease.find(params[:id])
    if @press_release.destroy
      flash[:notice] = "Deleted press release \"#{@press_release.title}\""
      redirect_to :action => "index", :restaurant_id => @restaurant.id
    end
  end

  def archive
    @press_releases = @restaurant.press_releases.all(:order => "created_at DESC")
  end

  private

  def find_restaurant
    @restaurant = Restaurant.find(params[:restaurant_id])
  end

  def require_manager
    if cannot? :edit, @restaurant
      flash[:error] = "You don't have permission to access that page"
      redirect_to @restaurant
    end
  end

end
