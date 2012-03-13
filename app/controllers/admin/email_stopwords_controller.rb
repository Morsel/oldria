class Admin::EmailStopwordsController < Admin::AdminController

  def index
    @stopwords = Admin::EmailStopword.all(:order => "created_at DESC")
  end

  def new
    @stopword = Admin::EmailStopword.new
  end

  def create
    stopwords = params[:admin_email_stopword][:phrase].split("\n")
    for stopword in stopwords
      Admin::EmailStopword.create(:phrase => stopword.strip)
    end
    redirect_to :action => "index"
  end

  def destroy
    @stopword = Admin::EmailStopword.find(params[:id])
    @stopword.destroy
    redirect_to :action => "index"
  end

end
