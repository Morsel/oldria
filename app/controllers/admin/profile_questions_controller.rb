class Admin::ProfileQuestionsController < Admin::AdminController
  
  def index
    @topics = Topic.all
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
    if @question.update_attributes(params[:profile_question])
      flash[:notice] = "Updated question #{@question.title}"
      redirect_to admin_profile_questions_path
    else
      render :action => "edit"
    end
  end
  
  def delete
    raise "Not implemented yet"
  end
  
  def manage
    @chapter = Chapter.find(params[:chapter_id])
    @questions = @chapter.profile_questions
  end
  
  def create_chapter
    @chapter = Chapter.new(params[:chapter])
    if @chapter.save
      flash[:notice] = "Created new chapter named #{@chapter.title}"
      redirect_to admin_profile_questions_path
    else
      render :action => "new"
    end
  end

  def create_topic
    @topic = Topic.new(params[:topic])
    if @topic.save
      flash[:notice] = "Created new topic named #{@topic.title}"
      redirect_to admin_profile_questions_path
    else
      render :action => "new"
    end
  end

end
