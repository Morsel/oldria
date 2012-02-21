class SiteSearchController < Soapbox::SiteSearchController

  layout 'application'

  def show
    super
    render :template => 'soapbox/site_search/show'
  end

end
