require "send_with_us"

module SendWithUsMailer
  class MailParams
    attr_accessor :to, :from, :email_id
    attr_reader   :email_data

    def initialize
      @email_data = {}
    end

    def assign(key, value)
      @email_data.merge!( key.to_sym => value )
    end

    def deliver
      SendWithUs::Api.new.send_with(@email_id, {address: @to}, @email_data, {reply_to: @from})
    end
  end
end
