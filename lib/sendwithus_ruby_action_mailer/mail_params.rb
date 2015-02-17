require "send_with_us"

module SendWithUsMailer
  class MailParams
    attr_reader :to, :from, :email_id, :email_data

    def initialize #:nodoc:
      @email_data = {}
      @to = {}
      @from = {}
      @cc = []
      @bcc = []
      @version_name = ""
      @locale = ""
      @files = []
    end

    def assign(key, value) #:nodoc:
      @email_data.merge!( key.to_sym => value )
    end

    def merge!(params={}) #:nodoc:
      params.each_pair do |key, value|
        case key
        when :email_id
          @email_id = value
        when :recipient_name
          @to.merge!(name: value)
        when :recipient_address
          @to.merge!(address: value)
        when :from_name
          @from.merge!(name: value)
        when :from_address
          @from.merge!(address: value)
        when :reply_to
          @from.merge!(reply_to: value)
        when :cc
          @cc.concat(value)
        when :bcc
          @bcc.concat(value)
        when :version_name
          @version_name = value
        when :locale
          @locale = value
        when :files
          @files.concat(value)
        end
      end
    end

    # Invoke <tt>SendWithUs::Api</tt> to deliver the message.
    # The <tt>SendWithUs</tt> module is implemented in the +send_with_us+ gem.
    #
    # IMPORTANT NOTE: <tt>SendWithUs</tt> must be configured prior to calling this method.
    # In particular, the +api_key+ must be set (following the guidelines in the
    # +send_with_us+ documentation).
    def deliver
      SendWithUs::Api.new.send_email(@email_id, @to, {data: @email_data, from: @from, cc: @cc, bcc: @bcc, version_name: @version_name, files: @files, locale: @locale})
    end
  end
end
