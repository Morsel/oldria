require_relative '../spec_helper'

describe Responsibility do
  it { should belong_to :subject_matter }
  it { should belong_to :employment }
end
