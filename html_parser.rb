require 'nokogiri'

class HTMLParser

  def initialize(body)
    @doc = Nokogiri::HTML(body)
    # p @doc
  end

  def remove_quote
    # delete blockquote nodes
    @doc.css('blockquote').remove

    # delete node with certain classes
    @doc.css('.gmail_quote').remove
    @doc.css('.gmail_extra').remove
    @doc.css('.moz-signature').remove

    # return the remaining html
    @doc.inner_html
  end

end
