#encoding: utf-8 
class RemoveSoapboxFlagFromEmploymentSearches < ActiveRecord::Migration
  def self.up
    EmploymentSearch.all.each do |search|
      search.conditions.delete(:post_to_soapbox)
      unless search.save
        puts "Can't save EmploymentSearch #{search.id}"
      end
    end
  end

  def self.down
    raise "Can't be reversed"
  end
end
