class Admin::AdminController < ApplicationController
  layout 'admin'

  before_filter :require_admin

  def index
  end

end
