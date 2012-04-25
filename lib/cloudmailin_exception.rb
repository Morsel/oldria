module CloudmailinException

  class MissingMessage < StandardError; end
  class MissingReplySeparator < StandardError; end
  class MessageTooShort < StandardError; end
  class DuplicateResponse < StandardError; end

end