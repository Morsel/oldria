#encoding: utf-8 
class AddManagementCompanyForRestaurants < ActiveRecord::Migration
  def self.up
    add_column :restaurants, :management_company_name, :string
    add_column :restaurants, :management_company_website, :string
  end

  def self.down
    remove_column :restaurants, :management_company_name
    remove_column :restaurants, :management_company_website
  end
end
