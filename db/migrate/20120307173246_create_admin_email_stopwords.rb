#encoding: utf-8 
class CreateAdminEmailStopwords < ActiveRecord::Migration
  def self.up
    create_table :email_stopwords do |t|
      t.text :phrase

      t.timestamps
    end
  end

  def self.down
    drop_table :email_stopwords
  end
end
