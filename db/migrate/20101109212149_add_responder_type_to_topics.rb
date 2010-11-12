class AddResponderTypeToTopics < ActiveRecord::Migration
  def self.up
    add_column :topics, :responder_type, :string
  end

  def self.down
    remove_column :topics, :responder_type
  end
end
