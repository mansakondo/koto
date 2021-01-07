# frozen_string_literal: true

module Koto
  module Parser
    module AST
      class Processor

        class Context
          attr_reader :scopes
          attr_reader :stack
          attr_reader :access

          def initialize
            @scopes  = SpaghettiStack.new(SymbolTable.new)
            @stack   = []
            @access  = :public

            freeze
          end

          def get_in(node)
            copy = self.deep_dup
            copy.send :get_in!, node
          end

          def get_in!(node)
            @scopes << SymbolTable.new
            @stack << node

            self.freeze
          end

          private :get_in!

          def get_out
            copy = self.deep_dup
            copy.send :get_out!
          end

          def get_out!
            symbol_table = symbols.freeze
            active_scope.update(symbol_table)

            unless top_level?
              @scopes.pop
              @stack.pop
            end

            return symbol_table, self.freeze
          end

          private :get_out!

          def save(node)
            copy = self.deep_dup
            copy.send :save!, node
          end

          def save!(node)
            symbol_table = symbols.record(node)
            active_scope.update(symbol_table)

            self.freeze
          end

          private :save!

          def symbols
            active_scope.data
          end

          def active_scope
            @scopes.top
          end

          def current_scope
            @stack.last
          end

          def switch_access_to(access)
            return self unless ACCESS_METHODS.include?(access) &&
              access != @access

            copy = self.dup
            copy.instance_variable_set(:@access, access)

            copy.freeze
          end

          def top_level?
            @stack.empty?
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
