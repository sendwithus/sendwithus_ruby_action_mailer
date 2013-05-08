module SendWithUsMailer
  class Base
    #------------------------- Class methods -----------------------------
    def self.default(value = nil)
      # TODO
    end

    def self.mailer_methods
      public_instance_methods - superclass.public_instance_methods
    end

    def self.method_missing(method_name, *args)
      if mailer_methods.include?(method_name.to_sym)
        new(method_name, *args).message
      else
        super
      end
    end

    def self.respond_to?(method, include_private = false)
      super || mailer_methods.include?(method.to_sym)
    end

    #----------------------- Instance methods ----------------------------
    attr_reader :message

    def initialize(method_name, *args)
      @message = MailParams.new
      self.send(method_name, *args)
    end

    def mail(params = {})
      @message.merge!(params)
    end
  end
end