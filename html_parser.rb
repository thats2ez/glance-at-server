require 'nokogiri'


class HTMLParser

  def initialize(body)
    @doc = Nokogiri::HTML(body)
    p @doc
  end

  def remove_quote

  end

end
