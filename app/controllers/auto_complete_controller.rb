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
      @keywords = ["RESTAURANTS BY KEYWORD"] + OtmKeyword.find(:all,:conditions => ["name like ?", "%#{keyword_name}%"],:limit => 2).map(&:name) + ["RESTAURANTS BY NAME"] + Restaurant.find(:all,:conditions => ["name like ?", "%#{keyword_name}%"],:limit => 2).map(&:name) + ["RESTAURANTS BY FEATURE"] + RestaurantFeature.find(:all,:conditions => ["value like ?", "%#{keyword_name}%"],:limit => 2).map(&:value) + ["RESTAURANTS BY CUISINE"] + Cuisine.find(:all,:conditions => ["name like ?", "%#{keyword_name}%"],:limit => 2).map(&:name)
    else
      @keywords = ["RESTAURANTS BY REGION"] + JamesBeardRegion.find(:all,:conditions => ["name like ? or description like ?", "%#{keyword_name}%","%#{keyword_name}%"],:limit => 5).map(&:name) + ["RESTAURANTS BY STATE"] + get_state_name_array.grep(/^#{keyword_name}/i)[0..5]
    end
    remove_value = ["RESTAURANTS BY CUISINE","RESTAURANTS BY STATE","RESTAURANTS BY OTM","RESTAURANTS BY REGION","RESTAURANTS BY FEATURE","RESTAURANTS BY NAME"]
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
      @keywords = ["PERSONS BY NAME"] + User.in_soapbox_directory.for_autocomplete.find_all_by_name(keyword_name).map(&:name)[0..4]
    else
      @keywords = ["PERSONS BY NAME"] + User.in_spoonfeed_directory.for_autocomplete.find_all_by_name(keyword_name).map(&:name)[0..4]
    end
    if params[:person]=="person"
      @keywords = @keywords + ["PERSONS BY SPECIALITY"] + Specialty.find(:all,:conditions => ["name like ?", "%#{keyword_name}%"],:limit => 4).map(&:name) + ["PERSONS BY CUISINE"] + Cuisine.find(:all,:conditions => ["name like ?","%#{keyword_name}%"],:limit => 4).map(&:name)
    else
      @keywords = ["PERSONS BY STATE"] + JamesBeardRegion.find(:all,:conditions => ["name like ?", "%#{keyword_name}%"],:limit => 7).map(&:name) + ["PERSONS BY REGION"] + MetropolitanArea.find(:all,:conditions => ["name like ?", "%#{keyword_name}%"],:limit => 7).map(&:name)
    end
    remove_value = ["PERSONS BY NAME","PERSONS BY SPECIALITY","PERSONS BY CUISINE","PERSONS BY STATE","PERSONS BY REGION"]
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