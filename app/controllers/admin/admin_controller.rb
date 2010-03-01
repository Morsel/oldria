class Admin::AdminController < ApplicationController
  layout 'admin'

  before_filter :require_admin
  skip_before_filter :preload_resources

  def index
  end

end
