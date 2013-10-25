
if defined?(Footnotes)
  module Footnotes
    class Filter
      if defined?(NewRelic)
        #@@notes.delete(:queries)
        @@notes << :rpm
      end
    end
  end
end