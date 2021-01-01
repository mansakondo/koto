# frozen_string_literal: true

module Koto
  module Parser
    module AST
      class Processor

        class NameProcessor < ::Parser::AST::Processor
          def on_const(node)
            scope, name = *node
            return name unless scope

            top_level = ::Parser::AST::Node.new(:cbase)

            if scope == top_level
              name = "::#{name}"
            else
              scope = process scope
              name  = "#{scope}::#{name}"
            end

            name.to_sym
          end
        end
      end
    end
  end
end
