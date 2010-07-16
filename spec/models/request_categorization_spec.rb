require 'spec/spec_helper'

describe RequestCategorization do
  should_belong_to :media_request
  should_belong_to :subject_matter
end
