class ProfileCuisine < ActiveRecord::Base
  
  belongs_to :cuisine
  belongs_to :profile

end
