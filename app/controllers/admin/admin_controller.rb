class Admin::AdminController < ApplicationController
  layout 'admin'

  before_filter :require_admin
  skip_before_filter :preload_resources, :only => 'read'
  before_filter :set_admin_section

  def index
  end

  private

  def set_admin_section
    @in_admin_section = true
  end
end
