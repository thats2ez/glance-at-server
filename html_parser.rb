require 'nokogiri'

class HTMLParser

  def initialize(body)
    @body = body
    # p @doc
  end

  def parsed_plain
    remove_quote unless @no_quote
    if @no_quote
      @no_quote.content
    else
      nil
    end
    # @doc.methods.sort
  end

  def no_quote
    remove_quote unless @no_quote
    if @no_quote
      @no_quote.inner_html
    else
      @body
    end
  end

  def has_unsubscribe_link?
    remove_quote unless @no_quote
    doc = @no_quote ? @no_quote : Nokogiri::HTML(@body)
    links = doc.xpath("//a")
    links.each do |link|
      content = link.content.downcase
      keywords = ['subscription', 'unsubscribe', 'notification', 'change your settings', 'amazon.com', 'click here', 'help center', 'get online support', 'contact us', 'view now']
      keywords.each do |keyword|
        # Rails.logger.info "content: #{content}"
        return true if content.include?(keyword)
      end
    end
    if links.count > 0
      plain_text = self.parsed_plain.downcase
      # Rails.logger.info "plain: #{plain_text}"
      keywords = ['stop receiving', 'unsubscribe', 'not receive', 'notification']
      keywords.each do |keyword|
        return true if plain_text.include?(keyword)
      end
    end
    false
  end

  private

  def remove_quote
    begin
    # deep copy
    doc = Nokogiri::HTML(@body)
    # delete blockquote nodes
    doc.css('blockquote').remove

    # delete node with certain classes
    doc.css('.gmail_quote').remove
    doc.css('.gmail_extra').remove
    doc.css('.moz-signature').remove

    # the remaining html
    no_quote_text = doc.inner_html

    # regex to match Microsoft Office quote
    reg = Regexp.new('<p class="MsoNormal"><b>.*From:.*(?=<\/div>\\s*<\/body>)', Regexp::MULTILINE)
    no_quote_text.sub!(reg, '')

    # regex to match plain text quote by gmail
    reg = Regexp.new('<br/>On (Mon|Tue|Wed|Thu|Fri|Sat|Sun),[^\\r\\n]*&lt;[^\\r\\n\\s]*@[^\\r\\n\\s]*&gt; wrote:.*', Regexp::MULTILINE)
    no_quote_text.sub!(reg, '')
    no_quote_text.gsub!("\r\n", "\n")
    no_quote_text.gsub!(/  +/, " ")
    no_quote_text.gsub!(/\n\n+/, "\n")
    @no_quote = Nokogiri::HTML(no_quote_text)
    rescue => err
      Rails.logger.error "remove quote failure: #{err}, raw body: #{@body}"
      @no_quote = nil
    end
  end

end
