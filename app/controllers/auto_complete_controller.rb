class AutoCompleteController < ApplicationController

  def index
  	 respond_to do |format|
      format.html
      format.js { auto_complete_keywords }
    end
  end

  def auto_complete_keywords
    keyword_name = params[:term]
    if params[:name]=="otm"
        @keywords = OtmKeyword.find(:all,:conditions => ["name like ?", "%#{keyword_name}%"],:limit => 15)
    elsif params[:name]=="restaurant"
    	@keywords = Restaurant.find(:all,:conditions => ["name like ?", "%#{keyword_name}%"],:limit => 15)
    elsif params[:name]=="feature"
    	@keywords = RestaurantFeature.find(:all,:conditions => ["value like ?", "%#{keyword_name}%"],:limit => 15)
    elsif params[:name]=="state"
    	@keywords = get_state_name_array.grep(/^#{keyword_name}/i)
    elsif params[:name]=="region"
      @keywords = JamesBeardRegion.find(:all,:conditions => ["name like ? or description like ?", "%#{keyword_name}%","%#{keyword_name}%"],:limit => 15)
    elsif params[:name]=="cuisine"
      @keywords = Cuisine.find(:all,:conditions => ["name like ?", "%#{keyword_name}%"],:limit => 15)
    end 	
    if @keywords.present?
      if params[:name]=="state"
      	render :json => @keywords
      else
      	render :json => @keywords.map(&:name)
      end
    else
    	if params[:name]=="otm"
	      UserMailer.deliver_send_otm_keyword_notification(current_user,keyword_name) 
	      render :json => @keywords.push('This keyword does not yet exist in our database. Please try another keyword.')
    	else
    	  render :json => @keywords.push('This '+params[:name]+' does not yet exist in our database. Please try another name.')
    	end
    end
  end

  def get_state_name_array
    return [ 'Alabama', 'AL', 'Alaska', 'AK', 'Arizona', 'AZ', 'Arkansas', 'AR', 'California', 'CA', 'Colorado', 'CO', 'Connecticut', 'CT', 'Delaware', 'DE', 'District of Columbia', 'DC', 'Florida', 'FL', 'Georgia', 'GA', 'Hawaii', 'HI', 'Idaho', 'ID', 'Illinois', 'IL', 'Indiana', 'IN', 'Iowa', 'IA', 'Kansas', 'KS', 'Kentucky', 'KY', 'Louisiana', 'LA', 'Maine', 'ME', 'Maryland', 'MD', 'Massachusetts', 'MA', 'Michigan', 'MI', 'Minnesota', 'MN', 'Mississippi', 'MS', 'Missouri', 'MO', 'Montana', 'MT', 'Nebraska', 'NE', 'Nevada', 'NV', 'New Hampshire', 'NH', 'New Jersey', 'NJ', 'New Mexico', 'NM', 'New York', 'NY', 'North Carolina', 'NC', 'North Dakota', 'ND', 'Ohio', 'OH', 'Oklahoma', 'OK', 'Oregon', 'OR', 'Pennsylvania', 'PA', 'Puerto Rico', 'PR', 'Rhode Island', 'RI', 'South Carolina', 'SC', 'South Dakota', 'SD', 'Tennessee', 'TN', 'Texas', 'TX', 'Utah', 'UT', 'Vermont', 'VT', 'Virginia', 'VA', 'Washington', 'WA', 'West Virginia', 'WV', 'Wisconsin', 'WI', 'Wyoming', 'WY' ]
  end

end