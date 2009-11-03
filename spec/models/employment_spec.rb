require 'spec_helper'

describe Employment do
  should_belong_to :employee, :class_name => "User"
  should_belong_to :restaurant
end
