# sendwithus Ruby Action Mailer

[sendwithus](http://sendwithus.com) is a service that provides a convenient way for non-developers
to create and edit the email content from your app. sendwithus has created a gem, `send_with_us`,
that communicates with our REST API for sending templated emails.

Ruby on Rails developers are familiar with the ActionMailer interface for sending email.  This
gem implements a small layer over the `send_with_us` gem that provides and ActionMailer-like API.

## Installation

Add this line to your application's Gemfile:

    gem 'sendwithus_ruby_action_mailer'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install sendwithus_ruby_action_mailer

## Setup

### Rails

For a Rails app, create `send_with_us.rb` in `/config/initializers/`
with the following:

```ruby
SendWithUs::Api.configure do |config|
    config.api_key = 'YOUR API KEY'
    config.debug = true
end
```

## Usage

Mailer models inherit from `SendWithUsMailer::Base`. A mailer model defines methods
used to generate an email message. In these methods, you can assign variables to be sent to
the Send With Us service and options on the mail itself such as the `:from` address.

`````Ruby
class Notifier < SendWithUsMailer::Base
    default from: 'no-reply@example.com'

    def welcome(recipient)
        assign(:account, recipient) 

        assign(:captain_name, recipient.name) 
        #=> in sendwithus email template {{ captain_name }}
        assign :team, {team_name: recipient.team_name, captain: recipient.name} 
        #=> in sendwithus email template {{ team.team_name }} and {{ team.captain }} 
        
        mail(
            email_id: 'ID-CODE-FROM-SEND-WITH-US', 
            recipient_address: recipient.email,
            bcc: [{:address => "name@example.com"},{:address => "name2@example.com"}])
    end
end
`````

Within the mailer method, you have access to the following methods:

* `assign` - Allows you to assign key-value pairs that will be
  data payload used by Send With Us within the email.
* `mail` - Allows you to specify the email to be sent.


### Sending mail

Once a mailer action is defined, you can deliver your message or create it and save it
for delivery later:

`````Ruby
Notifier.welcome(nick).deliver # sends the email

mail = Notifier.welcome(david)  # => a SendWithUsMailer::MailParams object
mail.deliver                    # sends the email
`````

You never instantiate your mailer class. Rather, you just call the method you defined
on the class itself.


### Default Hash

SendWithUsMailer allows you to specify default values inside the class definition:

`````Ruby
class Notifier < SendWithUsMailer::Base
    default from: 'system@example.com'
end
`````

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
