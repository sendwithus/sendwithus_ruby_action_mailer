require "active_job"

module SendWithUsMailer
  module Jobs
    # The <tt>SendWithUsMailer::Jobs::MailJob</tt> class is used when you
    # want to send transactional emails outside of the request-response cycle.
    class MailJob < ActiveJob::Base
      queue_as :mailers

      def perform(email_id, to, options)
        SendWithUs::Api.new.send_email(email_id, to, options)
      end
    end
  end
end