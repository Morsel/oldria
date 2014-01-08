require_relative '../../spec_helper'

describe Restaurants::SocialPostController do
  integrate_views

  before(:each) do
    @social_posts = FactoryGirl.create(:social_post)
    SocialPost.skip_callback(:create, :after, :schedule_post)
    @user = FactoryGirl.create(:admin)
    @user.stubs(:update).returns(true)
    controller.stubs(:current_user).returns(@user)
    controller.stubs(:require_admin).returns(true)
  end

end
