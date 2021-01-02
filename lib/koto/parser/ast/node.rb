# frozen_string_literal: true

module Koto
  module Parser
    module AST
      class Node < ::Parser::AST::Node
        attr_reader :name
        attr_reader :context

        def scope
          context.current_scope
        end

        def access
          context.access
        end

        def symbols
          context.symbols
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
        end
      end
    end
  end
end
