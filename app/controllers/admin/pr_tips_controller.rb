class Admin::PrTipsController < Admin::AdminController

  def new
    @admin_pr_tip = Admin::PrTip.new
    search_setup
  end

  def create
    @admin_pr_tip = Admin::PrTip.new(params[:admin_pr_tip])
    @search = Employment.search(normalized_search_params)
    @admin_pr_tip.recipients = @search.all
    if @admin_pr_tip.save
      flash[:notice] = "Successfully created PR Tip"
      redirect_to admin_messages_path
    else
      render :new
    end
  end

  def edit
    @admin_pr_tip = Admin::PrTip.find(params[:id])
  end

  def update
    @admin_pr_tip = Admin::PrTip.find(params[:id])
    if @admin_pr_tip.update_attributes(params[:admin_pr_tip])
      flash[:notice] = "Successfully updated PR Tip"
      redirect_to admin_messages_path
    else
      render :edit
    end
  end
end
