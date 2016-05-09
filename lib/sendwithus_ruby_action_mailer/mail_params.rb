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
      @headers = {}
      @tags = []
      @esp_account = ""
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
        when :headers
          @headers.merge!(value)
        when :tags
          @tags.concat(value)
        when :esp_account
          @esp_account = value
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
      SendWithUs::Api.new.send_email(
        @email_id,
        @to,
        data: @email_data,
        from: @from,
        cc: @cc,
        bcc: @bcc,
        esp_account: @esp_account,
        version_name: @version_name,
        locale: @locale,
        files: @files,
        headers: @headers,
        tags: @tags
      ) if @email_id.present?
    end

    alias_method :deliver_now, :deliver

    # Invoke <tt>SendWithUs::Api</tt> to deliver the message later via ActiveJob.
    # The <tt>SendWithUs</tt> module is implemented in the +send_with_us+ gem.
    #
    # IMPORTANT NOTE: <tt>SendWithUs</tt> must be configured prior to calling this method.
    # In particular, the +api_key+ must be set (following the guidelines in the
    # +send_with_us+ documentation).
    def deliver_later
      Jobs::MailJob.perform_later(
          @email_id,
          @to,
          data: @email_data,
          from: @from,
          cc: @cc,
          bcc: @bcc,
          esp_account: @esp_account,
          version_name: @version_name,
          locale: @locale,
          files: @files,
          headers: @headers,
          tags: @tags
      ) if @email_id.present?
    end
  end
end
