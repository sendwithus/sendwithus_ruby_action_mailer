require "active_job"

class MailJob < ActiveJob::Base
  queue_as :default

  def perform(*args)
    SendWithUs::Api.new.send_email(args)
  end
end