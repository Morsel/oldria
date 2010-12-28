module MailerHelper
  def indefenite_article(word)
    (word.to_s =~ /^[aeio]+/i) ? "an" : "a"
  end
end
