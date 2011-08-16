class Admin::SiteActivitiesController < Admin::AdminController

  def index
    @activities = SiteActivity.all
  end

end
