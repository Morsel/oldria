#encoding: utf-8 
class AddSlugToSoapboxFeaturedItems < ActiveRecord::Migration
  def self.up
    add_column :admin_messages, :slug, :string
    add_column :trend_questions, :slug, :string
  end

  def self.down
    remove_column :trend_questions, :slug
    remove_column :admin_messages, :slug
  end
end