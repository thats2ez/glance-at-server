require 'treat'
require 'chronic'
include Treat::Core::DSL

class NaturalLanguageParser

  @@request_keywords =
    ['let me know', 'Let me know', 'send me', 'Send me']

  def initialize(message)
    @message = message
  end

  def requests
    parse_requests unless @requests
    @requests
  end

  def request_with_date(now = nil)
    # parse if not yet parsed
    parse_dates(now) unless @dates
    # get the first request with non-nil date
    @requests.each_with_index do |item, index|
      return { request: item, date: @dates[index] } if @dates[index]
    end
    nil
  end

  private

  def parse_requests
    @requests = self.class.sentences(@message).select { |s| self.class.request? s }
  end

  def parse_dates(now = nil)
    # parse if not yet parsed
    parse_requests unless @requests
    # get date for every request
    @dates = @requests.map { |request| self.class.date_in_request(request, now) }
  end

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

  def self.date_in_request(text, now)
    Chronic.parse(text, :now => now)
  end


end
