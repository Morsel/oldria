#encoding: utf-8 
class ChangeMediaRequestsToSubjectMatter < ActiveRecord::Migration
  def self.up
    rename_column :media_requests, :media_request_type_id, :subject_matter_id
    drop_table :request_categorizations
  end

  def self.down
    rename_column :media_request, :subject_matter_id, :media_request_type_id
    create_table :request_categorizations, :force => true do |t|
      t.integer  :media_request_id
      t.integer  :subject_matter_id
      t.datetime :created_at
      t.datetime :updated_at
    end
  end
end