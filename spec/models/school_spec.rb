require_relative '../spec_helper'

describe School do
  it { should validate_presence_of :city }
  it { should validate_presence_of :state }
  it { should validate_presence_of :country }
  it { should validate_presence_of :name }
  it { should have_many :enrollments }
  it { should have_many(:profiles).through(:enrollments) }
end

