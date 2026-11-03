class ApplicationMailbox < ActionMailbox::Base
  routing /^support@example\.com$/i => :support
  routing "support@example.com" => :support
end
