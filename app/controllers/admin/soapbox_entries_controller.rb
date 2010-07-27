class Admin::SoapboxEntriesController < Admin::AdminController

  def index
    @soapbox_entries = SoapboxEntry.all
  end

  def new
    find_featured_item
    @soapbox_entry = SoapboxEntry.new(:featured_item => @featured_item)
  end

  def create
    @soapbox_entry = SoapboxEntry.new(params[:soapbox_entry])
    if @soapbox_entry.save
      redirect_to admin_soapbox_entries_path
    else
      render :new
    end
  end

  def edit
    @soapbox_entry = SoapboxEntry.find(params[:id])
  end

  def update
    @soapbox_entry = SoapboxEntry.find(params[:id])
    if @soapbox_entry.update_attributes(params[:soapbox_entry])
      redirect_to admin_soapbox_entries_path
    else
      render :edit
    end
  end

  private

  def find_featured_item
    @featured_item = if params[:qotd_id]
      Admin::Qotd.find(params[:qotd_id])
    elsif params[:trend_question_id]
      TrendQuestion.find(params[:trend_question_id])
    else
      nil
    end
  end
end
