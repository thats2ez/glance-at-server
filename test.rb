def generateConversation
  message = Hash.new
  message['subject'] = 'Meeting Next Week'
  message['plain'] = 'How about Monday\'s afternoon? I am busy in the morning.'
  message['receivedAt'] = Time.new
  message['from'] = "thats2ez@gmail.com"
  message['to'] = "masterrrofthehouse@gmail.com"

  conversation = {'messages' => [message]}
end

def generateUser
  user = {'address' => 'masterrrofthehouse'}
end

require_relative 'filter'
require_relative 'nlp'
require_relative 'html_parser'
# result = GlanceAt.RequestFilter(conversation, user)
# print result

# message = 'The first step once a textual entity has been created is usually to split it into smaller bits and pieces that are more useful to work with? Treat allows to successively split a text into logical zones, sentences, syntactical phrases, and, finally, tokens (which include words, numbers, punctuation, etc.) Let me know if all text processors work destructively on the receiving object, returning the modified object. They add the results of their operations in the @children hash of the receiving object. Note that each of type of processor is only available on specific types of entities, which are bolded in the text below.'
#
# s = NaturalLanguageParser.sentences(message)
# s.each do | line |
#   # p NaturalLanguageParser.words(line)
#   # p line
#   # p NaturalLanguageParser.request? line
# end
#
# parser = NaturalLanguageParser.new(message)
# p parser.requests
# # text = 'Let me know if all text processors work destructively on the receiving object, returning the modified object.'
# # p text.end_with? '?' || ['let me know', 'Let me know', 'send me', 'Send me'].any? { |w| text.include? w }
#
# body = File.open('/Users/kaiqi/Desktop/test_gmail_quote.txt', 'r')
# mp = HTMLParser.new(body)
# p mp.remove_quote
#
# input = File.open('/Users/kaiqi/Projects/idealab_client/idealab_clientTests/Input3.html', 'r').read()
#
# # reg = Regexp.new('<p class="MsoNormal"><b>.*From:.*(?=<\/div>\\s*<\/body>)', Regexp::MULTILINE)
#
# reg = Regexp.new('<br/>On (Mon|Tue|Wed|Thu|Fri|Sat|Sun),[^\\r\\n]*&lt;[^\\r\\n\\s]*@[^\\r\\n\\s]*&gt; wrote:.*', Regexp::MULTILINE)
#
# # p reg.match(input)
#
# p input.sub!(reg, '')
#
#
c =
  ['Let me know if you\'re available on the Friday.',
    'How\'s Monday afternoon?',
    'Does 11am on the 3rd work for you?',
    'Let me know if you\'re available on the Friday.',
    'Next Tuesday at 8am at Idealab?',
    'Let me know if you are free for a call early next week.',
    'Thursday next week for drinks?',
    'I’d love to catch up – how about Tuesday?'].join ' '
# c.each { |text| p NaturalLanguageParser.new(text).parse_dates Time.now }

n = NaturalLanguageParser.new(c)
p n.request_with_date
p n.requests

n2 = NaturalLanguageParser.new('hahahahahahaha?')
p n2.request_with_date
p n2.requests

n2 = NaturalLanguageParser.new('')
p n2.request_with_date
p n2.requests
