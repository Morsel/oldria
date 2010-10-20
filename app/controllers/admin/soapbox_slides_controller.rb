class Admin::SoapboxSlidesController < Admin::AdminController
  
  def index
    @slides = SoapboxSlide.all(:order => :position)
  end
  
  def new
    @slide = SoapboxSlide.new
  end
  
  def create
    @slide = SoapboxSlide.new(params[:soapbox_slide])
    if @slide.save
      flash[:notice] = "Created new slide \"#{@slide.title}\""
      redirect_to :action => "index"
    else
      render :action => :new
    end
  end
  
  def edit
    @slide = SoapboxSlide.find(params[:id])
  end
  
  def update
    @slide = SoapboxSlide.find(params[:id])
    if @slide.update_attributes(params[:soapbox_slide])
      flash[:notice] = "Updated slide \"#{@slide.title}\""
      redirect_to :action => "index"
    else
      render :action => :edit
    end      
  end
  
  def destroy
    @slide = SoapboxSlide.find(params[:id])
    @slide.destroy
    flash[:notice] = "Deleted slide \"#{@slide.title}\""
    redirect_to :action => "index"
  end
  
  def sort
    if params[:soapbox_slides]
      params[:soapbox_slides].each_with_index do |id, index|
        SoapboxSlide.update_all(['position=?', index+1], ['id=?', id])
      end      
    end
    render :nothing => true
  end
  
end
