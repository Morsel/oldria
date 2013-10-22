class Admin::PageViewsController < Admin::AdminController
	require 'will_paginate/array'
  def index
    @page_views = PageView.all(:order => "created_at DESC").paginate(:page => params[:page])
  end

  def trace_keyword_for_soapbox
    @soapbox_trace_keywords = SoapboxTraceKeyword.all(:order => "created_at DESC").paginate(:page => params[:page])
  end



end
