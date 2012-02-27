class PressReleasesController < ApplicationController

  before_filter :find_restaurant
  before_filter :require_manager

  def index
    @press_release = @restaurant.press_releases.build
    @press_release.pdf_remote_attachment = PdfRemoteAttachment.new
  end

  def create
    @press_release = @restaurant.press_releases.build(params[:press_release])
    if @press_release.save
      flash[:notice] = "Your press release has been saved"
      redirect_to :action => "index"
    else
      flash[:error] = @press_release.errors.full_messages.to_sentence
      render :action => "index"
    end
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
