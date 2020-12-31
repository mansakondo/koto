# frozen_string_literal: true

module Koto
  module Parser
    module AST
      class Node < ::Parser::AST::Node
        attr_reader :name
        attr_reader :context

        def scope
          scopes = context.scopes
          scopes.last
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
            @context = context
          end
        end
      end
    end
  end
end
