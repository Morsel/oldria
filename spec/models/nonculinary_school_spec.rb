require_relative '../spec_helper'

describe NonculinarySchool do
  it { should validate_presence_of :city }
  it { should validate_presence_of :state }
  it { should validate_presence_of :country }
  it { should validate_presence_of :name }
  it { should have_many :nonculinary_enrollments }
  it { should have_many(:profiles).through(:nonculinary_enrollments) }
end

