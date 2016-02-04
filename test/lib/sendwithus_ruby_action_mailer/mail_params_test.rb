require_relative '../../test_helper'

describe SendWithUsMailer::MailParams do
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
      SendWithUs::Api.any_instance.expects(:send_with)
      subject.deliver
    end

    it "doesnt call the send_with_us gem if perform_delivery = false" do
      subject.perform_delivery = false
      SendWithUs::Api.any_instance.expects(:send_with).never
      subject.deliver
    end

  end
end