class Admin::TrendQuestionsController < Admin::AdminController

  def index
    @trend_questions = ::TrendQuestion.by_scheduled_date.by_subject.all(:include => :employment_search)
  end

  def show
    @trend_question = ::TrendQuestion.find(params[:id])
    @trend_question.scheduled_at = (@trend_question.new_record? ? Time.now : @trend_question.scheduled_at)
    search_setup(@trend_question)
  end

  def new
    @trend_question = ::TrendQuestion.new
    @trend_question.scheduled_at = (@trend_question.new_record? ? Time.now : @trend_question.scheduled_at)
    search_setup(@trend_question)
  end

  def create
    @trend_question = ::TrendQuestion.new(params[:trend_question])
    build_search(@trend_question)
    @employment_search.save
    if @trend_question.save
      flash[:notice] = "Successfully created trend question."
      redirect_to([:admin, @trend_question])
    else
      @solo_users, @restaurants_and_employments = @search.all.partition { |e| e.restaurant.nil? }
      @restaurants_and_employments = @restaurants_and_employments.group_by(&:restaurant)
      render :action => 'new'
    end
  end

  def edit
    @trend_question = ::TrendQuestion.find(params[:id], :include => :employment_search)
    @trend_question.scheduled_at = (@trend_question.new_record? ? Time.now : @trend_question.scheduled_at)
    search_setup(@trend_question)
  end

  def update
    @trend_question = ::TrendQuestion.find(params[:id])
    build_search(@trend_question)
    @employment_search.save
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
