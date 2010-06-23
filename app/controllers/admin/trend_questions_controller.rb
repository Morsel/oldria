class Admin::TrendQuestionsController < Admin::AdminController
  def index
    @trend_questions = ::TrendQuestion.by_scheduled_date.by_subject.all(:include => :employment_search)
  end

  def show
    @trend_question = ::TrendQuestion.find(params[:id])
    search_setup(@trend_question)
  end

  def new
    @trend_question = ::TrendQuestion.new
    search_setup(@trend_question)
  end

  def create
    @trend_question = ::TrendQuestion.new(params[:trend_question])
    search_setup(@trend_question)
    save_search
    if @trend_question.save
      flash[:notice] = "Successfully created trend question."
      redirect_to([:admin, @trend_question])
    else
      render :action => 'new'
    end
  end

  def edit
    @trend_question = ::TrendQuestion.find(params[:id], :include => :employment_search)
    search_setup(@trend_question)
  end

  def update
    @trend_question = ::TrendQuestion.find(params[:id])
    search_setup(@trend_question)
    save_search
    if @trend_question.update_attributes(params[:trend_question])
      flash[:notice] = "Successfully updated trend question."
      redirect_to([:admin, @trend_question])
    else
      render :action => 'edit'
    end
  end

  def destroy
    @trend_question = ::TrendQuestion.find(params[:id])
    @trend_question.destroy
    flash[:notice] = "Successfully destroyed trend question."
    redirect_to admin_trend_questions_path
  end
end
