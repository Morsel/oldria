class Admin::ProfileQuestionsController < Admin::AdminController
  
  def index
    @chapters = Chapter.all(:order => "position ASC, topic_id ASC, title ASC")
  end
  
  def new
    @question = ProfileQuestion.new
  end
  
  def create
    @question = ProfileQuestion.new(params[:profile_question])
    if @question.save
      flash[:notice] = "Added new profile question"
      redirect_to admin_profile_questions_path
    else
      render :action => "new"
    end
  end
  
  def edit
    @question = ProfileQuestion.find(params[:id])
  end
  
  def update
    @question = ProfileQuestion.find(params[:id])
    chapter_params = params[:profile_question].delete("chapter_ids")
    chapters = Chapter.find(chapter_params)
    if @question.update_attributes(params[:profile_question].merge(:chapters => chapters))
      flash[:notice] = "Updated question \"#{@question.title}\""
      redirect_to :action => "manage", :chapter_id => params[:chapter_id]
    else
      render :action => "edit"
    end
  end
  
  def destroy
    @question = ProfileQuestion.find(params[:id])
    flash[:notice] = "Deleted question \"#{@question.title}\""
    @question.destroy
    redirect_to admin_profile_questions_path
  end
  
  def manage
    @chapter = Chapter.find(params[:chapter_id])
    @questions = @chapter.profile_questions.all(:include => :chapter_question_memberships, 
        :order => "chapter_question_memberships.position ASC")
  end
  
  def sort
    if params[:chapters]
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
