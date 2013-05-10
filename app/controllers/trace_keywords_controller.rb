class TraceKeywordsController < ApplicationController
	 
	def create
	  if current_user.media?
	        @trace_keyword =  TraceKeyword.find_by_keywordable_id_and_keywordable_type_and_user_id(params[:trace_keyword][:keywordable_id], params[:trace_keyword][:keywordable_type],current_user.id)	        
	        @trace_keyword = @trace_keyword.nil? ? TraceKeyword.create(params[:trace_keyword]) : @trace_keyword.increment!(:count)  
	  end	  	
	  	respond_to do |format|
      	format.js { render :json => @trace_keyword }
	    end
  end

end
