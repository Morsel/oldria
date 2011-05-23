class Soapbox::SoapboxController < ApplicationController

  def index
    @home = true

    @alm_links = ALaMinuteQuestion.answered.all(:order => "question").uniq
    @btl_links = Topic.user_topics.without_travel.all(:order => "title")
    @travel_links = Topic.travel.chapters.answered_by_premium_users[0...4] if Topic.travel
    @newsfeed_links = PromotionType.used_by_promotions.all(:order => :name).uniq

    @alm_questions = ALaMinuteQuestion.most_recent_for_soapbox(4)
    @btl_questions = ProfileQuestion.without_travel.recently_answered.answered_by_premium_users[0...4]
    @promotions = Promotion.from_premium_restaurants.current(:limit => 4)

    @main_feature = SoapboxEntry.main_feature
    @secondary_feature = SoapboxEntry.secondary_feature
  end

  def directory
    if params[:specialty_id]
      @specialty = Specialty.find(params[:specialty_id])
      @users = User.in_soapbox_directory.profile_specialties_id_eq(params[:specialty_id]).all(:order => "users.last_name").uniq
    elsif params[:cuisine_id]
      @cuisine = Cuisine.find(params[:cuisine_id])
      @users = User.in_soapbox_directory.profile_cuisines_id_eq(params[:cuisine_id]).all(:order => "users.last_name").uniq
    else
      directory_search_setup
      @use_search = true
    end

    @no_sidebar = true
    render :template => "directory/index"
  end

  def directory_search
    directory_search_setup
    render :partial => "directory/search_results"
  end

  def restaurant_directory
    @restaurants = Restaurant.with_premium_account
    @no_sidebar = true
    render :template => "directory/restaurants"
  end

  def restaurant_search
    @restaurants = Restaurant.with_premium_account.search(params[:search]).all
    render :partial => "directory/restaurant_search_results"
  end

  def travel_guides
    redirect_to soapbox_topic_path(Topic.travel)
  end

end
