require_relative '../../test_helper'

describe SendWithUsMailer::Base do
  class FirstMailer < SendWithUsMailer::Base
    def send_an_email; end
  end

  class SecondMailer < SendWithUsMailer::Base
    def send_a_second_email; end
  end

  describe "#default" do
    it "responds to default" do
      SendWithUsMailer::Base.must_respond_to :default
      FirstMailer.must_respond_to :default
    end
  end

  describe "#mailer_methods" do
    it "finds the instance methods defined in the classes" do
      FirstMailer.mailer_methods.must_include(:send_an_email)
      SecondMailer.mailer_methods.must_include(:send_a_second_email)
    end

    it "does not include instance methods from other mailers" do
      FirstMailer.mailer_methods.wont_include(:send_a_second_email)
      SecondMailer.mailer_methods.wont_include(:send_an_email)
    end

    it "does not include the Base class instance methods" do
      SendWithUsMailer::Base.public_instance_methods.each do |method|
        FirstMailer.mailer_methods.wont_include(method)
      end
    end
  end

  describe "methods should be called on the class object" do
    class ThirdMailer < SendWithUsMailer::Base
      def send_an_email # an instance method
        @@test_result = "instance method send_an_email"
      end

      def self.test_result; @@test_result; end
    end

    it "class responds to mailer methods" do
      ThirdMailer.respond_to?(:send_an_email).must_equal true
    end

    it "class wraps the call to the instance method" do
      ThirdMailer.send_an_email
      ThirdMailer.test_result.must_equal "instance method send_an_email"
    end

    it "returns a MailParams object" do
      FirstMailer.send_an_email.must_be_kind_of SendWithUsMailer::MailParams
    end
  end
end