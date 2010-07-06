class Admin::EventsController < Admin::AdminController
  
  def new
    @event = Event.new
    @event.attachments.build
  end
  
  def create
    @event = Event.new(params[:event])
    if @event.save
      flash[:notice] = "Created #{@event.title}"
      redirect_to admin_calendars_path
    else
      render :action => "new"
    end
  end
  
  def show
    @event = Event.find(params[:id])
    render :template => "events/show"
  end

  def edit
    find_event
    @event.attachments.build if @event.attachments.blank?
  end
  
  def update
    find_event
    if @event.update_attributes(params[:event])
      flash[:notice] = "Updated #{@event.title}"
      redirect_to admin_calendars_path
    else
      render :action => :edit
    end
  end
  
  def destroy
    find_event
    flash[:notice] = "Deleted #{@event.title}"
    @event.destroy
    redirect_to admin_calendars_path
  end
  
  private
  
  def find_event
    @event = Event.find(params[:id])
  end
  
end
