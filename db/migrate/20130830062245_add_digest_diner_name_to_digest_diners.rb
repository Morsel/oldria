class AddDigestDinerNameToDigestDiners < ActiveRecord::Migration
  def self.up
  	["National Diner","Regional Diner","Local Diner"].each do |name|
  		digest_diner = DigestDiner.new
  		digest_diner.name = name
  		digest_diner.save
  	end
  end

  def self.down
  	DigestDiner.all.destroy_all
  end
end
