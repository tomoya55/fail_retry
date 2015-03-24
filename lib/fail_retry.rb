require "fail_retry/version"

module FailRetry
  class Fail < RuntimeError; end

  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods
    def fail_retry(method_name, exception: Fail, max_tries: 1, on_retry: nil)
      define_method("#{method_name}_with_retry") do |*args, &block|
        trial = 0
        begin
          send("#{method_name}_without_retry", *args, &block)
        rescue => e
          raise if !e.kind_of?(exception) || trial >= max_tries
          on_retry.call(self) if on_retry
          trial += 1
          retry
        end
      end

      alias_method "#{method_name}_without_retry", method_name
      alias_method method_name, "#{method_name}_with_retry"
    end
  end
end
