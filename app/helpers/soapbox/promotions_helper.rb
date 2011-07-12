module Soapbox::PromotionsHelper

  def newsfeed_title
    if @promotion_type.present?
      "Newsfeed: #{@promotion_type.name}"
    elsif @restaurant.present?
      "Newsfeed: #{@restaurant.name}"
    else
      "Newsfeed"
    end
  end
end
