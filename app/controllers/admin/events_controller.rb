class Admin::EventsController < ApplicationController
  
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
  
end
