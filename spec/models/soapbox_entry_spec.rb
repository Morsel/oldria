require_relative '../spec_helper'

describe SoapboxEntry do
  should_belong_to :featured_item, :polymorphic => true
end

