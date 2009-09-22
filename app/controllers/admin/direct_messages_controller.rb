class Admin::DirectMessagesController < Admin::AdminController

  def index
    @direct_messages = DirectMessage.all_from_admin
  end

  def show
    @direct_message = DirectMessage.find(params[:id])
  end

  def new
    @direct_message = DirectMessage.new
    @direct_message.from_admin = true
  end

  def edit
    @direct_message = DirectMessage.find(params[:id])
  end

  def create
    @direct_message = current_user.sent_direct_messages.build(params[:direct_message])
    @direct_message.from_admin = true
    if @direct_message.save
      flash[:notice] = 'Direct message was successfully created.'
      redirect_to(admin_direct_messages_url)
    else
      render :new
    end
  end

  def update
    @direct_message = DirectMessage.find(params[:id])
    if @direct_message.update_attributes(params[:direct_message])
      flash[:notice] = 'Direct message was successfully updated.'
      redirect_to(admin_direct_messages_url)
    else
      render :edit
    end
  end

  def destroy
    @direct_message = DirectMessage.find(params[:id])
    @direct_message.destroy
    redirect_to(admin_direct_messages_url)
  end
end
