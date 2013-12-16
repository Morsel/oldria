require "xpath" # XPath is a separate gem now

module Cucumber
  module Rails
    module CapybaraSelectDatesAndTimes
      def select_date(field, options = {})
        date     = Date.parse(options[:with])
        selector = %Q{.//fieldset[contains(./legend, "#{field}")]}
        # within(:xpath, selector) do
        #   find(:xpath, '//select[contains(@id, "_1i")]').find(:xpath, ::XPath::HTML.option(date.year.to_s)).select_option
        #   find(:xpath, '//select[contains(@id, "_2i")]').find(:xpath, ::XPath::HTML.option(date.strftime('%B').to_s)).select_option
        #   find(:xpath, '//select[contains(@id, "_3i")]').find(:xpath, ::XPath::HTML.option(date.day.to_s)).select_option
        # end
      end

      def select_time(field, options = {})
        time     = Time.parse(options[:with])
        selector = %Q{.//fieldset[contains(./legend, "#{field}")]}
        within(:xpath, selector) do
          find(:xpath, '//select[contains(@id, "_4i")]').find(:xpath, ::XPath::HTML.option(time.hour.to_s.rjust(2,'0'))).select_option
          find(:xpath, '//select[contains(@id, "_5i")]').find(:xpath, ::XPath::HTML.option(time.min.to_s.rjust(2,'0'))).select_option
        end
      end

      def select_datetime(field, options = {})
        select_date(field, options)
        select_time(field, options)
      end
    end
  end
end

World(Cucumber::Rails::CapybaraSelectDatesAndTimes)
