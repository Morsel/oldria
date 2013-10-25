#encoding: utf-8 
class CreateOtmKeywordNotifications < ActiveRecord::Migration
  def self.up
    create_table :otm_keyword_notifications do |t|
      t.string :name

      t.timestamps
    end
  end

  def self.down
    drop_table :otm_keyword_notifications
  end
end
