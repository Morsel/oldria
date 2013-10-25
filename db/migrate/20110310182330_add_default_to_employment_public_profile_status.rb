#encoding: utf-8 
class AddDefaultToEmploymentPublicProfileStatus < ActiveRecord::Migration
  def self.up
    change_column_default :employments, :public_profile, true
    Employment.all.each { |e| e.update_attribute(:public_profile, true) if e.public_profile.nil? }
  end

  def self.down
    change_column_default :employments, :public_profile, nil
  end
end