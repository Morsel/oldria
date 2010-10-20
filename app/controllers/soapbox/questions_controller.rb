class Soapbox::QuestionsController < QuestionsController
  # all actions inherit, this is just there to make routing/template selection easier
  
  layout 'soapbox'
  
  def index
    super
    render :template => 'questions/index'
  end
  
  def show
    super
    render :template => 'questions/show'
  end
  
  def topics
    super
    render :template => 'questions/topics'
  end
  
  def chapters
    super
    render :template => 'questions/chapters'
  end
  
end
