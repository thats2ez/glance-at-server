require 'nokogiri'

class HTMLParser

  def initialize(body)
    @body = body
    # p @doc
  end

  def remove_quote
    # deep copy
    doc = Nokogiri::HTML(@body)
    # delete blockquote nodes
    doc.css('blockquote').remove

    # delete node with certain classes
    doc.css('.gmail_quote').remove
    doc.css('.gmail_extra').remove
    doc.css('.moz-signature').remove

    # the remaining html
    @no_quote = doc.inner_html

    # regex to match Microsoft Office quote
    reg = Regexp.new('<p class="MsoNormal"><b>.*From:.*(?=<\/div>\\s*<\/body>)', Regexp::MULTILINE)
    @no_quote.sub!(reg, '')

    # regex to match plain text quote by gmail
    reg = Regexp.new('<br/>On (Mon|Tue|Wed|Thu|Fri|Sat|Sun),[^\\r\\n]*&lt;[^\\r\\n\\s]*@[^\\r\\n\\s]*&gt; wrote:.*', Regexp::MULTILINE)
    @no_quote.sub!(reg, '')
  end

  def highlight_request(request)
    # deep copy
    doc = Nokogiri::HTML(@body)

    @highlighted = doc.inner_html
  end

end
