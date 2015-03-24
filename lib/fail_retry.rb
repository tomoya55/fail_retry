require "fail_retry/version"

module FailRetry
  class Fail < RuntimeError; end

  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods
    def fail_retry(method_name, on: Fail, max: 1, if: nil)
      define_method("#{method_name}_with_retry") do |*args, &block|
        trial = 0
        begin
          send("#{method_name}_without_retry", *args, &block)
        rescue => e
          exception = on
          if_proc = binding.local_variable_get(:if)
          retriable = e.kind_of?(exception)
          retriable &&= trial < max
          retriable &&= if_proc ? if_proc.call(self) : true

          if retriable
            trial = trial.succ
            retry
          else
            raise
          end
        end
      end

      alias_method "#{method_name}_without_retry", method_name
      alias_method method_name, "#{method_name}_with_retry"
    end
  end
end
