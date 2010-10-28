class MoveSoapboxPreferenceToEmployments < ActiveRecord::Migration
  def self.up
    add_column :employments, :post_to_soapbox, :boolean, :default => true
    Employment.all.each do |e|
      e.update_attribute(:post_to_soapbox, e.prefers_post_to_soapbox?)
    end
  end

  def self.down
    remove_column :employments, :post_to_soapbox
  end
end
