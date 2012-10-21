module SanUltari
  module Command
    def self.included target
      target.extend ClassMethods
    end

    module ClassMethods
      @registry = {}

      def map command, clazz, options = nil
      end

      def param command, param, options = nil
      end

      def option command, option, options = nil
      end

      def import clazz, operation = nil
      end

      def group group_name, clazz, operation = nil
      end

      def run
      end
    end
  end

  class CommandRunner
  end
end
