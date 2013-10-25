#encoding: utf-8 
class AddFieldsToPages < ActiveRecord::Migration
  def self.up
    add_column :pages, :title, :string
    add_column :pages, :slug, :string
    add_column :pages, :content, :text
  end

  def self.down
    remove_column :pages, :content
    remove_column :pages, :slug
    remove_column :pages, :title
  end
end
