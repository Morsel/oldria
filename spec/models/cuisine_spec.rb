require_relative '../spec_helper'

describe Cuisine do
  it { should have_many :restaurants }
  it { should have_many :profile_cuisines }
  it { should have_many :profiles }

  #CIS http://stackoverflow.com/questions/6853744/how-can-i-have-rspec-test-for-my-default-scope
  it { Cuisine.scoped.to_sql.should == Cuisine.order("cuisines.name ASC").to_sql }
#    it { should have_default_scope :order => "cuisines.name ASC" } 
  it { should validate_presence_of :name }
 # it { should have_scope :with_restaurants }
   it { Cuisine.with_restaurants.to_sql.should == "SELECT `cuisines`.* FROM `cuisines` INNER JOIN `restaurants` ON `restaurants`.`cuisine_id` = `cuisines`.`id` WHERE (restaurants.deleted_at IS NULL) GROUP BY cuisines.id ORDER BY cuisines.name ASC" }
end
