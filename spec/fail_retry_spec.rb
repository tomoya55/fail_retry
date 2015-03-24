require 'spec_helper'

describe FailRetry do
  let(:klass) do
    Class.new do
      include FailRetry

      attr_accessor :value

      def initialize
        @value = 0
      end

      def call(number)
        perform_action(number)
      end

      private

      def perform_action(number)
        number / value
      end
    end
  end

  let(:instance) do
    klass.new
  end

  subject do
    instance.call(1)
  end

  context "when a method call succeeds" do
    before do
      klass.fail_retry :call, on: ZeroDivisionError, if: -> (instance) { instance.value += 1 }
    end

    it "retries and return number" do
      expect(subject).to eq(1)
    end
  end

  context "when an unexpected exception happened" do
    before do
      klass.fail_retry :call, on: ArgumentError
      klass.send(:undef_method, :perform_action)
    end

    it "raises exception" do
      expect { subject }.to raise_error(NameError)
    end
  end

  context "when a method call fails and max is 0" do
    before do
      klass.fail_retry :call, on: ZeroDivisionError, max: 0
    end

    it "retries without retry" do
      expect(instance).to receive(:perform_action).exactly(1).times.and_call_original
      expect { subject }.to raise_error(ZeroDivisionError)
    end
  end

  context "when a method call fails until trial reaches max_tries" do
    before do
      klass.fail_retry :call, on: ZeroDivisionError, max: 3
    end

    it "retries and raise error" do
      expect(instance).to receive(:perform_action).exactly(4).times.and_call_original
      expect { subject }.to raise_error(ZeroDivisionError)
    end
  end
end
