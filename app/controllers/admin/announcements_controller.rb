class Admin::AnnouncementsController < Admin::AdminController
  def new
    @admin_announcement = Admin::Announcement.new
    @admin_announcement.attachments.build
  end

  def create
    @admin_announcement = Admin::Announcement.new(params[:admin_announcement])
    if @admin_announcement.save
      flash[:notice] = "Successfully created Announcement."
      redirect_to admin_messages_path
    else
      render :new
    end
  end

  def edit
    @admin_announcement = Admin::Announcement.find(params[:id])
  end

  def update
    @admin_announcement = Admin::Announcement.find(params[:id])
    if @admin_announcement.update_attributes(params[:admin_announcement])
      flash[:notice] = "Successfully updated Announcement."
      redirect_to admin_messages_path
    else
      render :edit
    end
  end
end
