require 'treat'
include Treat::Core::DSL

class NaturalLanguageParser

  @@request_keywords =
    ['let me know', 'Let me know', 'send me', 'Send me']

  def initialize(message)
    @message = message
  end

  def requests
    self.class.sentences(@message).select { |s| self.class.request? s }
  end

  private

  def self.sentences(text)
    paragraph(text).segment(:srx).to_a
  end

  def self.words(text)
    sentence(text).tokenize(:ptb).to_a
  end

  def self.request?(text)
    if text.end_with? '?'
      true
    else
      @@request_keywords.any? { |w| text.include? w }
    end
  end
end
