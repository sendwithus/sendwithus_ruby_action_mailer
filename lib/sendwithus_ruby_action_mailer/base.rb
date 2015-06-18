require "action_pack"
require "abstract_controller"

module SendWithUsMailer
  # Mailer models inherit from <tt>SendWithUsMailer::Base</tt>. A mailer model defines methods
  # used to generate an email message. In these methods, you can assign variables to be sent to
  # the Send With Us service and options on the mail itself such as the <tt>:from</tt> address.
  #
  #   class Notifier < SendWithUsMailer::Base
  #     default from: 'no-reply@example.com'
  #
  #     def welcome(recipient)
  #       assign(:account, recipient)
  #       mail(email_id: 'ID-CODE-FROM-SEND-WITH-US', to: recipient.email)
  #     end
  #   end
  #
  # Within the mailer method, you have access to the following methods:
  #
  # * <tt>assign</tt> - Allows you to assign key-value pairs that will be
  #   data payload used by SendWithUs to interpolate the content.
  # * <tt>mail</tt> - Allows you to specify email to be sent.
  #
  # The mail method is used to set the header parameters.
  #
  #
  # = Sending mail
  #
  # Once a mailer action is defined, you can deliver your message or create it and save it
  # for delivery later:
  #
  #   Notifier.welcome(david).deliver # sends the email
  #   mail = Notifier.welcome(david)  # => a SendWithUsMailer::MailParams object
  #   mail.deliver                    # sends the email
  #
  # You never instantiate your mailer class. Rather, you just call the method you defined
  # on the class itself.
  #
  #
  # = Default Hash
  #
  # SendWithUsMailer allows you to specify default values inside the class definition:
  #
  #   class Notifier < SendWithUsMailer::Base
  #     default from: 'system@example.com'
  #   end
  class Base < AbstractController::Base
    abstract!

    #---------------------- Singleton methods ----------------------------
    class << self
      def defaults
        @defaults || {}
      end

      # Set default values for any of the parameters passed to the <tt>#mail</tt>
      # method. For example:
      #
      #   class Notifier < SendWithUsMailer::Base
      #     default  from: 'no-reply@test.lindsaar.net',
      #              reply_to: 'bounces@test.lindsaar.net'
      #   end
      def default(value = nil)
        @defaults = defaults.merge(value)
      end

      # Inherit defaults from ancestor
      def inherited(heir)
        heir.__send__(:default, defaults)
      end

      # Return the mailer methods that are defined in any instance
      # of <tt>SendWithUsMailer::Base</tt>. There should not be
      # any reason to call this directly.
      def mailer_methods
        public_instance_methods - superclass.public_instance_methods
      end

      # We use <tt>::method_missing</tt> to delegate
      # mailer methods to a new instance and return the
      # <tt>SendWithUsMailer::MailParams</tt> object.
      def method_missing(method_name, *args)
        if mailer_methods.include?(method_name.to_sym)
          new(method_name, *args).message
        else
          super
        end
      end

      # Add our mailer_methods to the set of methods the mailer responds to.
      def respond_to?(method_name, include_all = false)
        mailer_methods.include?(method_name.to_sym) || super
      end
    end

    #----------------------- Instance methods ----------------------------
    attr_reader :message

    # Instantiate a new mailer object. If +method_name+ is not +nil+, the mailer
    # will be initialized according to the named method.
    def initialize(method_name, *args)
      @message = MailParams.new
      self.send(method_name, *args)
    end

    # The main method that creates the message parameters.  The method accepts
    # a headers hash. This hash allows you to specify the certain headers
    # in an email message, these are:
    #
    # * <tt>:email_id</tt> - The unique code associated with the SendWithUs specific email.
    # * <tt>:recipient_address</tt> - Who the message is destined for. Must be a valid email address.
    # * <tt>:recipient_name</tt> - Recipient's name
    # * <tt>:from_address</tt> - Who the message is from. Must be a valid email address.
    # * <tt>:from_name</tt> - Who the email is from
    # * <tt>:reply_to</tt> - Who to set the Reply-To header of the email to.
    #
    # You can set default values for any of the above headers by using the <tt>::default</tt>
    # class method.
    #
    # For example:
    #
    #   class Notifier < ActionMailer::Base
    #     default from: 'no-reply@test.example.net'
    #
    #     def welcome
    #       mail(email_id: 'EMAIL_ID from Send With Us', to: 'dave@test.example.net')
    #     end
    #   end
    def mail(params = {})
      @message.merge!(self.class.defaults.merge(params))
    end

    # Assign variables that will be sent in the payload to Send With Us.
    #
    # For example:
    #
    #   class Notifier < ActionMailer::Base
    #     def welcome
    #
    #       assign :login_url, "http://thefastguys.example.com"
    #       assign :user, {name: "Dave Lokhorst", role: "admin"}
    #       assign :team, {name: "The Fast Guys", captain: "Joe"}
    #
    #       mail(email_id: 'EMAIL_ID from Send With Us', to: 'dave@test.example.net')
    #     end
    #   end
    #
    # makes the following parameters accessible to the Send With Us email:
    #   {{ login_url }} => "http://thefastguys.example.com"
    #   {{ user.name }} => "Dave Lokhorst"
    #   {{ user.role }} => "admin"
    #   {{ team.name }} => "The Fast Guys"
    #   {{ team.captain }} => "Joe"
    def assign(key, value)
      @message.assign(key, value)
    end
  end
end
