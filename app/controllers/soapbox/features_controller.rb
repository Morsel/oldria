class Soapbox::FeaturesController < FeaturesController
  
  def show
    super
    render :template => 'features/show'
  end

end
