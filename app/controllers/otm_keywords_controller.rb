class OtmKeywordsController < ApplicationController
 
  def index
    respond_to do |format|
      format.html
      format.js { auto_complete_otmkeywords }
    end
  end	

  def auto_complete_otmkeywords
    otm_keyword_name = params[:term]
    @otm_keywords = OtmKeyword.find(:all,:conditions => ["name like ?", "%#{otm_keyword_name}%"],:limit => 15)
    if @otm_keywords.present?
      render :json => @otm_keywords.map(&:name)
    else
      UserMailer.deliver_log_file("Start send OTM keyword search by - #{current_user.first_name}")      
      UserMailer.deliver_send_otm_keyword_notification(current_user,otm_keyword_name)
      UserMailer.deliver_log_file("Success send OTM keyword are - #{otm_keyword_name}") 
      render :json => @otm_keywords.push('This keyword does not yet exist in our database. Please try another keyword.')
    end
  end

end
