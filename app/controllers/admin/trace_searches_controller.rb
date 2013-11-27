class Admin::TraceSearchesController < ApplicationController

  def index
  	@trace_searches = TraceSearch.all(:order => "created_at DESC").paginate(:page => params[:page])
  end

  def trace_search_for_soapbox
  	@soapbox_trace_searches = SpoonfeedTraceSearche.all(:order => "created_at DESC").paginate(:page => params[:page])
  end 	

end
