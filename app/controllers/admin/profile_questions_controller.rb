class Admin::ProfileQuestionsController < Admin::AdminController
  
  def index
    @question = ProfileQuestion.all
  end
  
  def new
    @question = ProfileQuestion.new
  end
  
  def create
    @question = ProfileQuestion.new(params[:question])
    if @question.save
      flash[:notice] = "Added new profile question"
      redirect_to admin_profile_questions_path
    end
  end

end
