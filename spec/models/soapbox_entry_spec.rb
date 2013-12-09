require_relative '../spec_helper'

describe SoapboxEntry do
  it { should belong_to(:featured_item) }
end

