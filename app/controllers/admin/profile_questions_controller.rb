class Admin::ProfileQuestionsController < Admin::AdminController

  before_filter :find_question, :only => [:edit, :update, :destroy, :send_notifications]

  def index
    @questions = ProfileQuestion.all(:conditions => ["topics.type IS NULL"],
                                     :include => { :chapter => :topic },
                                     :order => "topics.title ASC, chapters.title ASC, profile_questions.position ASC").
                                     group_by(&:chapter)
  end

  def new
    @question = ProfileQuestion.new
    @roles = RestaurantRole.all.group_by(&:category)
    @topics = Topic.user_topics
  end

  def create
    @question = ProfileQuestion.new(params[:profile_question])
    if @question.save
      flash[:notice] = "Added new profile question \"#{@question.title}\""
      redirect_to :action => "index"
    else
      @roles = RestaurantRole.all.group_by(&:category)
      @topics = Topic.user_topics
      render :action => "new"
    end
  end

  def edit
    @roles = RestaurantRole.all.group_by(&:category)
    @topics = Topic.user_topics
  end

  def update
    if @question.update_attributes(params[:profile_question])
      flash[:notice] = "Updated question \"#{@question.title}\""
      redirect_to :action => "index"
    else
      @roles = RestaurantRole.all.group_by(&:category)
      @topics = Topic.user_topics
      render :action => "edit"
    end
  end

  def destroy
    flash[:notice] = "Deleted question \"#{@question.title}\""
    @question.destroy
    redirect_to :action => "index"
  end

  def sort
    if params[:topics]
      params[:topics].each_with_index do |id, index|
        Topic.update_all(['position=?', index+1], ['id=?', id])
      end
    elsif params[:chapters]
      params[:chapters].each_with_index do |id, index|
        Chapter.update_all(['position=?', index+1], ['id=?', id])
      end
    elsif params[:profile_questions]
      params[:profile_questions].each_with_index do |id, index|
        ProfileQuestion.update_all(['position=?', index+1], ['id=?', id])
      end
    end
    render :nothing => true
  end

  def send_notifications
    @question.notify_users!
    flash[:notice] = "Notification emails sent for \"#{@question.title}\""
    redirect_to :action => "index"
  end

  private

  def find_question
    @question = ProfileQuestion.find(params[:id])
  end

end
