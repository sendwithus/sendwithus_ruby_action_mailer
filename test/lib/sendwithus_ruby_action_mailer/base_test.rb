require_relative '../../test_helper'

describe SendWithUsMailer::Base do
  class FirstMailer < SendWithUsMailer::Base
    def send_an_email; end
  end

  class SecondMailer < SendWithUsMailer::Base
    def send_a_second_email; end
  end

  describe "::default" do
    it "responds to default" do
      SendWithUsMailer::Base.must_respond_to :default
      FirstMailer.must_respond_to :default
    end
  end

  describe "::mailer_methods" do
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
      def send_an_email(a=nil,b=nil) # an instance method
      end
    end

    it "class wraps the call to the mailer method (which is an instance method)" do
      ThirdMailer.any_instance.expects(:send_an_email)
      ThirdMailer.send_an_email
    end

    it "calls to mailer methods return a MailParams object" do
      FirstMailer.send_an_email.must_be_kind_of SendWithUsMailer::MailParams
    end

    it "relays the arguments to the instance" do
      ThirdMailer.any_instance.expects(:send_an_email).with("a","b")
      ThirdMailer.send_an_email("a","b")
    end
  end

  describe "#assign" do
    class MailerWithAssign < SendWithUsMailer::Base
      def example
        assign :user, "dave"
      end
    end

    it "delegates the method to its message" do
      SendWithUsMailer::MailParams.any_instance.expects(:assign)
      MailerWithAssign.example
    end
  end
end