class Admin::QotdsController < Admin::AdminController
  def new
    @qotd = Admin::Qotd.new
  end

  def create
    @qotd = Admin::Qotd.new(params[:admin_qotd])
    if @qotd.save
      flash[:notice] = "Successfully created Question of the Day"
      redirect_to admin_messages_path
    else
      render :new
    end
  end

  def edit
    @qotd = Admin::Qotd.find(params[:id])
  end

  def update
    @qotd = Admin::Qotd.find(params[:id])
    if @qotd.update_attributes(params[:admin_qotd])
      flash[:notice] = "Successfully updated Question of the Day"
      redirect_to admin_messages_path
    else
      render :edit
    end
  end

  def destroy
    @qotd = Admin::Qotd.find(params[:id])
    @qotd.destroy
    flash[:notice] = "Successfully destroyed Question of the Day"
    redirect_to admin_messages_path
  end
end
