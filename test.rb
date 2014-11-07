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
  user = {'address' = 'masterrrofthehouse'}
end

p conversation

require_relative 'filter'

result = GlanceAt.RequestFilter(conversation, user)
print result
