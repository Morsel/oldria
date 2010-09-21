class Admin::InvitationsController < Admin::AdminController
  
  def index
    @invitations = Invitation.all(:order => "created_at DESC")
  end
  
  def edit
    @invitation = Invitation.find(params[:id])
  end
  
  def update
    @invitation = Invitation.find(params[:id])
    if @invitation.update_attributes(params[:invitation])
      flash[:notice] = "Updated invitation"
      redirect_to :action => "index"
    else
      render :action => "edit"
    end
  end
  
  def destroy
    @invitation = Invitation.find(params[:id])
    @invitation.destroy
    flash[:notice] = "Deleted invitation"
    redirect_to :action => "index"
  end
  
  def accept
  end

end
