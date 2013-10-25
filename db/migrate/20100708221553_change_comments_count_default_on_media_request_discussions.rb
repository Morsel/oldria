#encoding: utf-8 
class ChangeCommentsCountDefaultOnMediaRequestDiscussions < ActiveRecord::Migration
  def self.up
    change_column_default :media_request_discussions, :comments_count, 0

    MediaRequestDiscussion.all.each do |mrd|
      mrd.comments_count || mrd.update_attribute(:comments_count, 0)
    end
  end

  def self.down
    change_column_default :media_request_discussions, :comments_count, nil
  end
end