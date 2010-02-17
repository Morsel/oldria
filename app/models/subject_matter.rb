# == Schema Information
#
# Table name: subject_matters
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class SubjectMatter < ActiveRecord::Base
  has_many :responsibilities
  has_many :employments, :through => :responsibilities
  validates_presence_of :name
  default_scope :order => :name

  def admin_only?
    name =~ /RIA/
  end
end
