class UpdateRestaurantFacebookTocken < ActiveRecord::Migration
  def self.up
  	 Restaurant.find(241,243,248,251).each do |row|
      row.update_attribute(:facebook_page_id, nil)
      row.update_attribute(:facebook_page_token, nil)    	
    end
  end

  def self.down
  end
end
