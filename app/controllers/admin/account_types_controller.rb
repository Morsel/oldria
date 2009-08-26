class Admin::AccountTypesController < Admin::AdminController
  def index
    @account_types = AccountType.all
  end
  
  def show
    @account_type = AccountType.find(params[:id])
  end
  
  def new
    @account_type = AccountType.new
  end
  
  def create
    @account_type = AccountType.new(params[:account_type])
    if @account_type.save
      flash[:notice] = "Successfully created account type."
      redirect_to admin_account_types_path
    else
      render :new
    end
  end
  
  def edit
    @account_type = AccountType.find(params[:id])
  end
  
  def update
    @account_type = AccountType.find(params[:id])
    if @account_type.update_attributes(params[:account_type])
      flash[:notice] = "Successfully updated account type."
      redirect_to admin_account_types_path
    else
      render :edit
    end
  end
  
  def destroy
    @account_type = AccountType.find(params[:id])
    @account_type.destroy
    flash[:notice] = "Successfully destroyed account type."
    redirect_to admin_account_types_url
  end
end
