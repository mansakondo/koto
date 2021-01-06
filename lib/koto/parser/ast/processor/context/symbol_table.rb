# frozen_string_literal: true

module Koto
  module Parser
    module AST
      class Processor::Context

        class SymbolTable < Hash
          def initialize(symbol = nil)
            record symbol if symbol
          end

          def record(symbol)
            self[symbol.name] = symbol
            self
          end

          def variables
            select do |_, symbol|
              [:lvasgn, :ivasgn, :cvasgn, :gvasgn].includes? symbol.type
            end
          end

          def instance_variables
            variables.select do |_, variable|
              variable.type == :ivasgn
            end
          end

          def private_instance_variables
            instance_variables.select do |_, instance_variable|
              instance_variable.access == :private
            end
          end

          def constants
            select do |_, symbol|
              symbol.type == :casgn
            end
          end

          def methods
            select do |_, symbol|
              [:def, :defs].include? symbol.type
            end
          end

          def instance_methods
            methods.select do |_, method|
              context = method.context

              method.type == :def and
              context.in_class? or context.in_module?
            end
          end

          def singleton_methods
            methods.select do |_, method|
              method.type == :defs
            end
          end

          def private_methods
            methods.select do |_, method|
              method.access == :private
            end
          end

          def private_instance_methods
            instance_methods.select do |_, instance_method|
              instance_method.access == :private
            end
          end

          def classes
            constants.select do |_, constant|
              _, value = *constant
              value.type == :class
            end
          end

          def modules
            constants.select do |_, constant|
              _, value = *constant
              value.type == :module
            end
          end
        end
      end
    end
  end
end
