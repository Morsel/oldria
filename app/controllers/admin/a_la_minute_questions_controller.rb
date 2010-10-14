class Admin::ALaMinuteQuestionsController < Admin::AdminController
  def index

  end

  def destroy
    question = ALaMinuteQuestion.find(params[:id])
    question.destroy

    redirect_to :action => :index
  end

  def create
    question = ALaMinuteQuestion.create(params[:a_la_minute_question])

    redirect_to :action => :index
  end

  # sent from the eip javascript function
  # see http://josephscott.org/code/javascript/jquery-edit-in-place/ for
  # parameters
  def edit_in_place
    id = params[:id].split("_")[-1]
    @question = ALaMinuteQuestion.find_by_id(id)
    @question.update_attributes(:question => params[:new_value])
    # @restaurant = Restaurant.find_by_id(params[:data].split("=").last)
    # if @restaurant && @question
    #   @answer = ALaMinuteAnswer.create(:answer => params[:new_value].strip,
    #       :responder => @restaurant, :a_la_minute_question => @question)
    # end
    if @question.valid?
      render :text => {:is_error => false, :error_text => nil, :html => @question.question}.to_json
    else
      render :text => {:is_error => true, :error_text => "Error updating answer",
          :html => params[:orig_value]}.to_json
    end
  end
end