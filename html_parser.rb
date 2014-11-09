require 'nokogiri'

class HTMLParser

  def initialize(body)
    @doc = Nokogiri::HTML(body)
    # p @doc
  end

  def remove_quote
    # deep copy
    @no_quote = Marshal.load(Marshal.dump(@doc))
    # delete blockquote nodes
    @no_quote.css('blockquote').remove

    # delete node with certain classes
    @no_quote.css('.gmail_quote').remove
    @no_quote.css('.gmail_extra').remove
    @no_quote.css('.moz-signature').remove

    # return the remaining html
    @no_quote.inner_html
  end

  def highlight_request(request)
    # deep copy
    @highlighted = Marshal.load(Marshal.dump(@doc))

    @highlighted.inner_html
  end

end
