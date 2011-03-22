class Admin::RestaurantQuestionsController < Admin::AdminController
  
  def index
    @questions = ProfileQuestion.all(:conditions => ["topics.responder_type = 'restaurant'"],
                                     :include => { :chapter => :topic },
                                     :order => "topics.title ASC, chapters.title ASC, profile_questions.position ASC").group_by(&:chapter)
  end

  def new
    @question = ProfileQuestion.new
    @topics = Topic.all(:conditions => { :responder_type => 'restaurant' })
  end

  def create
    @question = ProfileQuestion.new(params[:profile_question])
    if @question.save
      flash[:notice] = "Added new restaurant question \"#{@question.title}\""
      redirect_to :action => "index"
    else
      @topics = Topic.all(:conditions => { :responder_type => 'restaurant' })
      render :action => "new"
    end
  end

  def edit
    @question = ProfileQuestion.find(params[:id])
    @topics = Topic.all(:conditions => { :responder_type => 'restaurant' })
  end

  def update
    @question = ProfileQuestion.find(params[:id])
    if @question.update_attributes(params[:profile_question])
      flash[:notice] = "Updated question \"#{@question.title}\""
      redirect_to :action => "index"
    else
      @topics = Topic.all(:conditions => { :responder_type => 'restaurant' })
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
        ProfileQuestion.update_all(['position=?', index+1], ['id=?', id])
      end
    end
    render :nothing => true
  end

end