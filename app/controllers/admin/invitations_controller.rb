class Admin::InvitationsController < Admin::AdminController
  
  def index
    @invitations = params[:archived] ? 
        Invitation.all(:order => "created_at DESC", :conditions => { :archived => true }) : 
        Invitation.all(:order => "created_at DESC", :conditions => { :archived => false })
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
    flash[:notice] = "Deleted invitation for #{@invitation.name}"
    @invitation.destroy
    redirect_to :action => "index"
  end
  
  def accept
  end

  def archive
    @invitation = Invitation.find(params[:id])
    @invitation.update_attribute(:archived, true)
    flash[:notice] = "Archived invitation for #{@invitation.name}"
    redirect_to :action => "index"
  end

end
