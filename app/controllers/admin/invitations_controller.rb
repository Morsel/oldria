class Admin::InvitationsController < Admin::AdminController
  
  before_filter :find_invite, :except => :index
  
  def index
    @invitations = params[:archived] ? 
        Invitation.all(:order => "created_at DESC", :conditions => { :archived => true }) : 
        Invitation.all(:order => "created_at DESC", :conditions => { :archived => false })
  end
  
  def edit
  end
  
  def update
    if @invitation.update_attributes(params[:invitation])
      flash[:notice] = "Updated invitation"
      redirect_to :action => "index"
    else
      render :action => "edit"
    end
  end
  
  def destroy
    flash[:notice] = "Deleted invitation for #{@invitation.name}"
    @invitation.destroy
    redirect_to :action => "index"
  end
  
  def accept
    token = Authlogic::Random.friendly_token
    @user = User.new(:first_name => @invitation.first_name, :last_name => @invitation.last_name, 
        :username => @invitation.username, :password => token, :password_confirmation => token, :email => @invitation.email, 
        :agree_to_contract => "1", :send_invitation => true, :invitation_sender => @invitation.requesting_user)
    if @user.save
      @user.confirm!
      @user.deliver_invitation_message!
      @invitation.update_attributes(:archived => true, :invitee_id => @user.id, :approved_at => Time.now)
      flash[:notice] = "Sent invitation to #{@invitation.email}"
      redirect_to :action => "index"
    end
  end

  def archive
    @invitation.update_attribute(:archived, true)
    flash[:notice] = "Archived invitation for #{@invitation.name}"
    redirect_to :action => "index"
  end
  
  private
  
  def find_invite
    @invitation = Invitation.find(params[:id])
  end

end
