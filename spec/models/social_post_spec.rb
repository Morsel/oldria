require_relative '../spec_helper'

describe SocialPost do
	it { should belong_to :source }
	it {should have_one (:delayed_job)}  
end 