class Admin::TrendQuestionsController < Admin::AdminController
  def index
    @trend_questions = ::TrendQuestion.all
  end

  def show
    @trend_question = ::TrendQuestion.find(params[:id])
  end

  def new
    @trend_question = ::TrendQuestion.new
    search_setup
  end

  def create
    @trend_question = ::TrendQuestion.new(params[:trend_question])
    search_setup
    if @trend_question.save
      save_search
      flash[:notice] = "Successfully created trend question."
      redirect_to admin_trend_questions_path
    else
      render :action => 'new'
    end
  end

  def edit
    @trend_question = ::TrendQuestion.find(params[:id], :include => :employment_search)
    search_setup
  end

  def update
    @trend_question = ::TrendQuestion.find(params[:id])
    search_setup
    if @trend_question.update_attributes(params[:trend_question])
      save_search
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
    @employment_search = if @trend_question.employment_search
        @trend_question.employment_search
      else
        @trend_question.build_employment_search(:conditions => {})
      end

    @search = @employment_search.employments #searchlogic
  end
  
  def save_search
    if params[:search]
      @employment_search.conditions = params[:search]
      @employment_search.save
    end
  end
end
