class Admin::TrendQuestionsController < Admin::AdminController
  def new
    @admin_trend_question = Admin::TrendQuestion.new

    @search = Employment.search(params[:search])

    if params[:search]
      @employments = @search.all(:select => 'DISTINCT employments.*', :include => [:restaurant])
      @search = Employment.search(nil) # reset the form
    end
  end

  def create
    @admin_trend_question = Admin::TrendQuestion.new(params[:admin_trend_question])
    @search = Employment.search(params[:search])
    if @admin_trend_question.save
      flash[:notice] = "Successfully created Trend Question"
      redirect_to admin_messages_path
    else
      render :new
    end
  end

  def edit
    @admin_trend_question = Admin::TrendQuestion.find(params[:id])
  end

  def update
    @admin_trend_question = Admin::TrendQuestion.find(params[:id])
    if @admin_trend_question.update_attributes(params[:admin_trend_question])
      flash[:notice] = "Successfully updated Trend Question"
      redirect_to admin_messages_path
    else
      render :edit
    end
  end
end
