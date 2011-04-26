require "#{Rails.root}/spec/factories"

require 'email_spec'
require 'email_spec/cucumber'
require 'factory_girl/step_definitions'
require 'ap'

include ActionView::Helpers::RecordIdentificationHelper

#### NOTE -- this is a patched workaround for an issue with webrat and
### formtastic for date selects and steps of the type
# When I select "November 23, 2004 11:20" as the "Preferred" date and time
# see
## https://webrat.lighthouseapp.com/projects/10503/tickets/388-select_date-broken-with-formtastic#ticket-388-2
module Webrat
  class Scope
    def locate_id_prefix(options, &location_strategy) #:nodoc:
      return options[:id_prefix] if options[:id_prefix]

      if options[:from]
        if (label = LabelLocator.new(@session, dom, options[:from]).locate)
          id_prefix = label.for_id
          if id_prefix =~ /(.*?)_[0-9]i$/
            $1
          else
            id_prefix
          end
        else
          raise NotFoundError.new("Could not find the label with text #{options[:from]}")
        end
      else
        yield
      end
    end
  end
end
