class Soapbox::RestaurantQuestionsController < Soapbox::SoapboxController

  def show
    @question = RestaurantQuestion.find(params[:id])
    @answers = @question.restaurant_answers.from_premium_restaurants.all(:order => "restaurant_answers.created_at DESC") \
        .select { |a| a.restaurant.try(:prefers_publish_profile?) }
    render :template => 'restaurant_questions/show'
  end

end
