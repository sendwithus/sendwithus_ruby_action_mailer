require_relative '../../test_helper'

describe SendWithUsMailer::MailParams do
  include ActiveJob::TestHelper

  subject { SendWithUsMailer::MailParams.new }

  describe "initialization" do
    it "email_data is empty on initialization" do
      subject.email_data.empty?.must_equal true
    end
  end

  describe "#assign" do
    let(:ep) { SendWithUsMailer::MailParams.new }

    it "adds (key,value) pairs to :email_data Hash" do
      ep.assign(:user, {:name => "Dave", :email => "dave@example.com"})
      ep.email_data.must_equal({
        :user => {:name => "Dave", :email => "dave@example.com"}
      })

      ep.assign(:url, "http://test.example.com")
      ep.email_data.must_equal({
        :user => {:name => "Dave", :email => "dave@example.com"},
        :url => "http://test.example.com"
      })
    end

    it "symbolizes the keys" do
      ep.assign("company", "Big Co Inc")
      ep.email_data.has_key?(:company).must_equal true
    end
  end

  describe "#email_id" do
    it "is readable" do
      subject.respond_to?(:email_id).must_equal true
      subject.respond_to?(:email_id=).must_equal false
    end
  end

  describe "#to" do
    it "is readable" do
      subject.respond_to?(:to).must_equal true
      subject.respond_to?(:to=).must_equal false
    end
  end

  describe "#from" do
    it "is readable" do
      subject.respond_to?(:from).must_equal true
      subject.respond_to?(:from=).must_equal false
    end
  end

  describe "#deliver" do
    it "method exists" do
      subject.respond_to?(:deliver).must_equal true
    end

    it "calls the send_with_us gem" do
      subject.merge!(email_id: 'x')
      SendWithUs::Api.any_instance.expects(:send_email)
      subject.deliver
    end

    it "doesn't call the send_with_us gem if mail method is not called" do
      SendWithUs::Api.any_instance.expects(:send_with).never
      subject.deliver
    end
  end

  describe "#deliver_now" do
    it "method exists" do
      subject.respond_to?(:deliver_now).must_equal true
    end

    it "calls the send_with_us gem" do
      subject.merge!(email_id: 'x')
      SendWithUs::Api.any_instance.expects(:send_email)
      subject.deliver_now
    end

    it "doesn't call the send_with_us gem if mail method is not called" do
      SendWithUs::Api.any_instance.expects(:send_with).never
      subject.deliver_now
    end
  end

  describe "#deliver_later" do
    it "method exists" do
      subject.respond_to?(:deliver_later).must_equal true
    end

    it "enqueues the job" do
      subject.merge!(email_id: 'x')
      assert_enqueued_with(job: SendWithUsMailer::Jobs::MailJob) do
        subject.deliver_later
      end
    end

    it "doesn't call the send_with_us gem if no email_id" do
      assert_no_enqueued_jobs do
        subject.deliver_later
      end
    end
  end
end