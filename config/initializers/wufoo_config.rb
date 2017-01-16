# requests from Wufoo will include this token to prove authenticity
Cohorts::Application.config.wufoo_handshake_key = ENV['WUFOO_HANDSHAKE_KEY']

Cohorts::Application.config.wufoo = WuParty.new(ENV['WUFOO_ACCOUNT'], ENV['WUFOO_API'])