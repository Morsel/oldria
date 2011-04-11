class Soapbox::RestaurantQuestionsController < RestaurantQuestionsController
  # all actions inherit, this is just there to make routing/template selection easier

  def index
    super
    render :template => 'restaurant_questions/index'
  end

  def show
    super
    render :template => 'restaurant_questions/show'
  end

  def topics
    super
    render :template => 'restaurant_questions/topics'
  end

  def chapters
    super
    render :template => 'restaurant_questions/chapters'
  end

end
