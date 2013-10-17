class AddFacebookPageUrlToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :facebook_page_url, :string
  end

  def self.down
    remove_column :users, :facebook_page_url
  end
end
