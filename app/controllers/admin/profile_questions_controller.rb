class Admin::ProfileQuestionsController < Admin::AdminController

  def index
    @questions = ProfileQuestion.all(
        :conditions => ["topics.responder_type = ?", h(params[:responder_type])],
        :include => { :chapter => :topic },
        :order => "topics.title ASC, chapters.title ASC, profile_questions.position ASC"
      ).group_by(&:chapter)
  end

  def new
    @question = ProfileQuestion.new
    @roles = RestaurantRole.all.group_by(&:category)
    @topics = Topic.all(:conditions => { :responder_type => params[:responder_type] })
  end

  def create
    @question = ProfileQuestion.new(params[:profile_question])
    if @question.save
      flash[:notice] = "Added new profile question \"#{@question.title}\""
      redirect_to :action => "index"
    else
      @roles = RestaurantRole.all.group_by(&:category)
      render :action => "new"
    end
  end

  def edit
    @question = ProfileQuestion.find(params[:id])
    @roles = RestaurantRole.all.group_by(&:category)
  end

  def update
    @question = ProfileQuestion.find(params[:id])
    if @question.update_attributes(params[:profile_question])
      flash[:notice] = "Updated question \"#{@question.title}\""
      redirect_to :action => "index"
    else
      @roles = RestaurantRole.all.group_by(&:category)
      render :action => "edit"
    end
  end

  def destroy
    @question = ProfileQuestion.find(params[:id])
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
        membership = ChapterQuestionMembership.find(:first,
            :conditions => { :profile_question_id => id, :chapter_id => params[:chapter_id] })
        membership.update_attributes(:position => (index + 1))
      end
    end
    render :nothing => true
  end

end
