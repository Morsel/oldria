module MailerHelper
  # FIXME - the word is spelled indefinite, and the message text could probably be rewritten to eliminate this helper
  def indefenite_article(word)
    (word.to_s =~ /^[aeio]+/i) ? "an" : "a"
  end
end
