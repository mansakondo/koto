# frozen_string_literal: true

module Koto
  module Parser
    module AST
      class Processor

        class Context
          attr_reader :stack
          attr_reader :access

          def initialize
            @stack  = []
            @access = :public
          end

          def get_in(node)
            stack << node
          end

          def get_out(node)
            stack.pop
          end

          def current_scope
            stack.last
          end

          def switch_access_to(access)
            return unless [:public, :private, :protected].include? access
            @access = access if access != @access
          end

          def top_level?
            stack.empty?
          end

          def in_class?
            return false if top_level?
            current_scope.type == :class
          end

          def in_sclass?
            return false if top_level?
            current_scope.type == :sclass
          end

          def in_module?
            return false if top_level?
            current_scope.type == :module
          end

          def in_def?
            return false if top_level?
            current_scope.type == :def
          end

          def in_block?
            return false if top_level?
            current_scope.type == :block
          end

          def in_lambda?
            return false if top_level?
            current_scope.type == :lambda
          end

          def in_dynamic_block?
            in_block? || in_lambda?
          end
        end
      end
    end
  end
end
