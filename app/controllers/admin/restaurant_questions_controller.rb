 class Admin::RestaurantQuestionsController < Admin::AdminController
  
  def index
    RestaurantQuestion.first.restaurant_user_without_answers
    @questions = RestaurantQuestion.all(:include => { :chapter => :topic },
        :order => "topics.title ASC, chapters.title ASC, restaurant_questions.position ASC").group_by(&:chapter)
  end

  def new
    @question = RestaurantQuestion.new
    @topics = RestaurantTopic.all
  end

  def create
    @question = RestaurantQuestion.new(params[:restaurant_question])
    if @question.save
      flash[:notice] = "Added new restaurant question \"#{@question.title}\""
      redirect_to :action => "index"
    else
      @topics = RestaurantTopic.all
      render :action => "new"
    end
  end

  def edit
    @question = RestaurantQuestion.find(params[:id])
    @topics = RestaurantTopic.all
  end

  def update
    @question = RestaurantQuestion.find(params[:id])
    if @question.update_attributes(params[:restaurant_question])
      flash[:notice] = "Updated question \"#{@question.title}\""
      redirect_to :action => "index"
    else
      @topics = RestaurantTopic.all
      render :action => "edit"
    end
  end

  def destroy
    @question = RestaurantQuestion.find(params[:id])
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
    elsif params[:restaurant_questions]
      params[:restaurant_questions].each_with_index do |id, index|
        RestaurantQuestion.update_all(['position=?', index+1], ['id=?', id])
      end
    end
    render :nothing => true
  end
  def send_notifications
    @question = RestaurantQuestion.find(params[:id])
    @question.notify_users!
    flash[:notice] = "Notification emails sent for \"#{@question.title}\""
    redirect_to :action => "index"
  end

end