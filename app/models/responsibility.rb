class Responsibility < ActiveRecord::Base
  belongs_to :subject_matter
  belongs_to :employment
end
