require 'treat'
require 'chronic'
require 'phone'
include Treat::Core::DSL

class NaturalLanguageParser

  @@request_keywords =
    ['let me know', 'send me', 'send over', 'lmk', 'please confirm']

  def initialize(message)
    @message = message
  end

  def requests
    parse_requests unless @requests
    @requests
  end

  def schedule_requests(now = nil)
    # parse if not yet parsed
    parse_schedule_requests(now) unless @schedule_requests_dates
    # get the first request with non-nil date
    result = []
    @requests.each_with_index do |request, index|
      result << { request_index: index, date: "#{@schedule_requests_dates[index]}" } if @schedule_requests_dates[index]
    end
    result
  end

  def file_requests
    parse_file_requests unless @file_requests
    @file_requests
  end

  def phone_numbers
    parse_phone_numbers unless @phone_numbers
    @phone_numbers
  end

  private

  def parse_requests
    @requests = []
    self.class.sentences(@message).each do |s|
      parsed_sentence = s.gsub(/<.*?>/, '').gsub(/[\r\n\u1427\u00a0]+/, '').lstrip.rstrip
      @requests << parsed_sentence if self.class.request?(parsed_sentence)
    end
    @requests
  end

  def parse_schedule_requests(now = nil)
    now = DateTime.now if now.nil?
    # parse if not yet parsed
    parse_requests unless @requests
    # get date for every request
    @schedule_requests_dates = @requests.map { |request| self.class.date_in_request(request, now) }
  end

  def parse_file_requests()
    parse_requests unless @requests

    @file_requests = []
    @requests.each_with_index do |request, index|
      @file_requests << { request_index: index } if request.downcase.include? 'send'
    end
    @file_requests
  end

  def parse_conference_call()
    
  end

  def self.sentences(text)
    paragraph(text).segment(:srx).to_a
  end

  def self.words(text)
    sentence(text).tokenize(:ptb).to_a
  end

  def self.request?(text)
    return false if text.nil?
    if text.end_with? '?'
      true
    else
      @@request_keywords.any? { |w| text.downcase.include? w }
    end
  end

  def self.date_in_request(text, now)
    parsed_text = text.gsub(/[\?\!,'";]+/, '')
    Chronic.parse(parsed_text, :now => now)
  end

end
