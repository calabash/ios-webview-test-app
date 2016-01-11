require 'briar'
require 'briar/irbrc'

puts 'loaded briar'

require 'pry'

# Patch Cucumber World for the irb
def World(*_)
  # nop
end

puts_calabash_environment
briar_message_of_the_day

APP="Products/app-cal/CalWebView-cal.app"
ENV["APP"] = APP

