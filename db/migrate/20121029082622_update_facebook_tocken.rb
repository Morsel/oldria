class UpdateFacebookTocken < ActiveRecord::Migration
  def self.up
  	User.find(1254,1261).each do |row|
      row.update_attribute(:facebook_id, nil)
      row.update_attribute(:facebook_access_token, nil)
      row.update_attribute(:facebook_page_token, nil)
      row.update_attribute(:facebook_page_id, nil)
      row.update_attribute(:facebook_token_expiration, nil)       	
    end
  end

  def self.down
  end
end
