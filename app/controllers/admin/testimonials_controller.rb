class Admin::TestimonialsController < Admin::AdminController

  def index
    @testimonials = Testimonial.by_position
  end

  def new
    @testimonial = Testimonial.new
  end

  def create
    @testimonial = Testimonial.new(params[:testimonial])
    if @testimonial.save
      redirect_to :action => "index"
    else
      render :action => "new"
    end
  end

  def edit
    @testimonial = Testimonial.find(params[:id])
  end

  def update
    @testimonial = Testimonial.find(params[:id])
    if @testimonial.update_attributes(params[:testimonial])
      redirect_to :action => "index"
    else
      render :action => "edit"
    end
  end

  def destroy
    @testimonial = Testimonial.find(params[:id])
    @testimonial.destroy
    redirect_to :action => "index"
  end

end
