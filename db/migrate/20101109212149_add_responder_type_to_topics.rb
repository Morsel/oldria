#encoding: utf-8 
class AddResponderTypeToTopics < ActiveRecord::Migration
  def self.up
    add_column :topics, :responder_type, :string

    Topic.all.each do |t|
      t.update_attribute(:responder_type, 'user')
    end
  end

  def self.down
    remove_column :topics, :responder_type
  end
end
