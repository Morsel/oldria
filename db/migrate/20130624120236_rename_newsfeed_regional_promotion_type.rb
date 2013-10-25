#encoding: utf-8 
class RenameNewsfeedRegionalPromotionType < ActiveRecord::Migration
   def self.up
        rename_table :newsfeed_regional_promotion_types, :newsfeed_promotion_types
    end
    def self.down
        rename_table :newsfeed_promotion_types, :newsfeed_regional_promotion_types
    end
end
