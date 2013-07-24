class AutoCompleteController < ApplicationController

  def index
    if params[:person]
      respond_to do |format|
        format.js { auto_complete_person_keywords }
      end   
    else
      respond_to do |format|
        format.js { auto_complete_keywords }
      end
    end
  end

  def auto_complete_keywords
    keyword_name = params[:term]    
    if params[:name]=="restaurant"
      @keywords = ["RESTAURANT BY OTM"] + OtmKeyword.find(:all,:conditions => ["name like ?", "%#{keyword_name}%"],:limit => 2).map(&:name) + ["RESTAURANT BY NAME"] + Restaurant.find(:all,:conditions => ["name like ?", "%#{keyword_name}%"],:limit => 2).map(&:name) + ["RESTAURANT BY FEATURE"] + RestaurantFeature.find(:all,:conditions => ["value like ?", "%#{keyword_name}%"],:limit => 2).map(&:value) + ["RESTAURANT BY CUISINE"]  + Cuisine.find(:all,:conditions => ["name like ?", "%#{keyword_name}%"],:limit => 2).map(&:name) 
    else
      @keywords = ["RESTAURANT BY REGION"]  + JamesBeardRegion.find(:all,:conditions => ["name like ? or description like ?", "%#{keyword_name}%","%#{keyword_name}%"],:limit => 5).map(&:name) + ["RESTAURANT BY STATE"] + get_state_name_array.grep(/^#{keyword_name}/i)[0..5]
    end
    remove_value = ["RESTAURANT BY CUISINE","RESTAURANT BY STATE","RESTAURANT BY OTM","RESTAURANT BY REGION","RESTAURANT BY FEATURE","RESTAURANT BY NAME"]
    test_result_search = @keywords.clone
    remove_value.each do |dels|
       test_result_search.delete("#{dels}")
    end
    unless test_result_search.present?      
      if params[:name]=="restaurant"
        UserMailer.deliver_send_otm_keyword_notification(current_user,keyword_name) 
      end
      render :json => test_result_search.push('This keyword does not yet exist in our database.')
    else
      render :json => @keywords
    end
  end

  def auto_complete_person_keywords
    keyword_name = params[:term]   
    if params[:soapbox]
      @keywords = ["PERSON BY NAME"] + User.in_soapbox_directory.for_autocomplete.find_all_by_name(keyword_name).map(&:name)[0..4]
    else
      @keywords = ["PERSON BY NAME"] + User.in_spoonfeed_directory.for_autocomplete.find_all_by_name(keyword_name).map(&:name)[0..4]
    end
    if params[:person]=="person"
      @keywords = @keywords + ["PERSON BY SPECIALITY"] + Specialty.find(:all,:conditions => ["name like ?", "%#{keyword_name}%"],:limit => 4).map(&:name) + ["PERSON BY CUISINE"] + Cuisine.find(:all,:conditions => ["name like ?","%#{keyword_name}%"],:limit => 4).map(&:name)
    else
      @keywords = ["PERSON BY STATE"] + JamesBeardRegion.find(:all,:conditions => ["name like ?", "%#{keyword_name}%"],:limit => 7).map(&:name) + ["PERSON BY REGION"] + MetropolitanArea.find(:all,:conditions => ["name like ?", "%#{keyword_name}%"],:limit => 7).map(&:name) 
    end
    remove_value = ["PERSON BY NAME","PERSON BY SPECIALITY","PERSON BY CUISINE","PERSON BY STATE","PERSON BY REGION"]
    test_result_search = @keywords.clone
    remove_value.each do |dels|
       test_result_search.delete("#{dels}")
    end
    unless test_result_search.present?      
      render :json => test_result_search.push('This keyword does not yet exist in our database.')
    else
      render :json => @keywords
    end
  end

  def get_state_name_array
    return [ 'Alabama', 'AL', 'Alaska', 'AK', 'Arizona', 'AZ', 'Arkansas', 'AR', 'California', 'CA', 'Colorado', 'CO', 'Connecticut', 'CT', 'Delaware', 'DE', 'District of Columbia', 'DC', 'Florida', 'FL', 'Georgia', 'GA', 'Hawaii', 'HI', 'Idaho', 'ID', 'Illinois', 'IL', 'Indiana', 'IN', 'Iowa', 'IA', 'Kansas', 'KS', 'Kentucky', 'KY', 'Louisiana', 'LA', 'Maine', 'ME', 'Maryland', 'MD', 'Massachusetts', 'MA', 'Michigan', 'MI', 'Minnesota', 'MN', 'Mississippi', 'MS', 'Missouri', 'MO', 'Montana', 'MT', 'Nebraska', 'NE', 'Nevada', 'NV', 'New Hampshire', 'NH', 'New Jersey', 'NJ', 'New Mexico', 'NM', 'New York', 'NY', 'North Carolina', 'NC', 'North Dakota', 'ND', 'Ohio', 'OH', 'Oklahoma', 'OK', 'Oregon', 'OR', 'Pennsylvania', 'PA', 'Puerto Rico', 'PR', 'Rhode Island', 'RI', 'South Carolina', 'SC', 'South Dakota', 'SD', 'Tennessee', 'TN', 'Texas', 'TX', 'Utah', 'UT', 'Vermont', 'VT', 'Virginia', 'VA', 'Washington', 'WA', 'West Virginia', 'WV', 'Wisconsin', 'WI', 'Wyoming', 'WY' ]
  end

end