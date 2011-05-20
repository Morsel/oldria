class Soapbox::SoapboxEntriesController < Soapbox::SoapboxController

  before_filter :hide_flashes

  def index
    @main_feature = SoapboxEntry.main_feature
    @main_feature_comments = SoapboxEntry.main_feature_comments if @main_feature

    @secondary_feature = SoapboxEntry.secondary_feature
    @secondary_feature_comments = SoapboxEntry.secondary_feature_comments if @secondary_feature
  end

  def show
    entry = SoapboxEntry.find(params[:id], :include => :featured_item)
    @feature = entry.featured_item
    @feature_comments = entry.comments
    @feature_type = entry.featured_item_type == 'Admin::Qotd' ? ' Question of the Day' : ' Trend'
  end

  def trend
    if params[:view_all]
      @featured_items = TrendQuestion.current.all(:order => "created_at DESC").paginate(:page => params[:page])
    else
      questions = SoapboxEntry.trend_question.published
      @featured_items = questions.map(&:featured_item).paginate(:page => params[:page], :include => :featured_item)
    end
    @no_sidebar = true
  end

  def qotd
    if params[:view_all]
      @featured_items = Admin::Qotd.current.all(:order => "created_at DESC", :limit => 10).paginate(:page => params[:page])
    else
      questions = SoapboxEntry.qotd.published
      @featured_items = questions.map(&:featured_item).paginate(:page => params[:page], :include => :featured_item)
    end
    @no_sidebar = true
  end

  protected

  def hide_flashes
    @hide_flashes = true
  end

end
