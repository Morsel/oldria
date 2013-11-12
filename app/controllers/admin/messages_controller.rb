class Admin::MessagesController < Admin::AdminController

  # GET /admin/messages
  # GET /admin/messages.xml
  def index
    @messages = Admin::Message.all(:limit=>10,:order => 'scheduled_at DESC, message ASC')
    @message_groups = @messages.group_by(&:class)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @messages }
    end
  end

  # GET /admin/messages/1
  # GET /admin/messages/1.xml
  def show
    @message = Admin::Message.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @message }
    end
  end

  # DELETE /admin/messages/1
  # DELETE /admin/messages/1.xml
  def destroy
    @message = Admin::Message.find(params[:id])
    @message.destroy
    respond_to do |format|
      format.html { redirect_to admin_message_path }
      format.xml { head :ok }
      format.js  { head :ok }
    end
  end
end
