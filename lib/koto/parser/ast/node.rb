# frozen_string_literal: true

module Koto
  module Parser
    module AST
      class Node < ::Parser::AST::Node
        attr_reader :name
        attr_reader :context
        attr_reader :symbols

        def parent_scope
          context.current_scope
        end

        def access
          context.access
        end

        def assign_properties(properties)
          super

          if (name = properties[:name])
            @name = name
          end

          if (context = properties[:context])
            context = context.deep_dup if context.frozen?
            @context = context
          end

          if (symbols = properties[:symbols])
            symbols = symbols.dup if symbols.frozen?
            @symbols = symbols
          end
        end
      end
    end
  end
end
