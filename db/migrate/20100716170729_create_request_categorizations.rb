#encoding: utf-8 
class CreateRequestCategorizations < ActiveRecord::Migration
  def self.up
    create_table :request_categorizations do |t|
      t.integer :media_request_id
      t.integer :subject_matter_id

      t.timestamps
    end

    add_index :request_categorizations, [:media_request_id, :subject_matter_id], :unique => true, :name => 'by_media_request_subject_matter'
    add_index :request_categorizations, :media_request_id
    add_index :request_categorizations, :subject_matter_id
  end

  def self.down
    remove_index :request_categorizations, :subject_matter_id
    remove_index :request_categorizations, :media_request_id
    remove_index :request_categorizations, :name => 'by_media_request_subject_matter'
    drop_table :request_categorizations
  end
end