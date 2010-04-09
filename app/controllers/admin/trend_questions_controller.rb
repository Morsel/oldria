class Admin::TrendQuestionsController < Admin::AdminController
  def index
    @trend_questions = ::TrendQuestion.all
  end

  def show
    @trend_question = ::TrendQuestion.find(params[:id])
  end

  def new
    @trend_question = ::TrendQuestion.new
    @trend_question.employment_search = EmploymentSearch.new(:conditions => {})
    @conditions = @trend_question.employment_search.conditions || {}
  end

  def create
    @trend_question = ::TrendQuestion.new(params[:trend_question])
    if @trend_question.save
      flash[:notice] = "Successfully created trend question."
      redirect_to admin_trend_questions_path
    else
      render :action => 'new'
    end
  end

  def edit
    @trend_question = ::TrendQuestion.find(params[:id], :include => :employment_search)
    #@trend_question.employment_search ||= EmploymentSearch.new(:conditions => {})
    @conditions = @trend_question.employment_search.conditions || {}
  end

  def update
    @trend_question = ::TrendQuestion.find(params[:id])
    if @trend_question.update_attributes(params[:trend_question])
      flash[:notice] = "Successfully updated trend question."
      redirect_to admin_trend_questions_path
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

  private
  def search_setup
    @search = Employment.search(params[:search])

    if params[:search]
      @employments = @search.all(:select => 'DISTINCT employments.*', :include => [:restaurant])
      @search = Employment.search(nil) # reset the form
    end
  end
end
