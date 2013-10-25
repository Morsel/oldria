#encoding: utf-8 
class MoveSoapboxPreferenceToEmployments < ActiveRecord::Migration
  def self.up
    add_column :employments, :post_to_soapbox, :boolean, :default => true
    Employment.all.each do |e|
      e.update_attribute(:post_to_soapbox, false) if e.prefers_post_to_soapbox == false
    end
  end

  def self.down
    remove_column :employments, :post_to_soapbox
  end
end
