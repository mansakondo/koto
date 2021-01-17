# frozen_string_literal: true

module Koto
  module Parser
    module AST
      class Processor
        class Resolver < ::Parser::AST::Processor
          attr_reader :processor
          attr_reader :context

          def initialize(processor)
            @processor = processor
            @context   = processor.context
          end

          def resolve(node)
            definition = process node
            return definition if definition
            nil
          end

          def on_const(node)
            name = node.name

            context.each do |scope|
              symbols    = scope.data
              constants  = symbols.constants
              definition = constants[name]

              return definition if definition
            end

            nil
          end

          def on_sym(node)
            name = node.children[0]

            context.each do |scope|
              symbols    = scope.data
              definition = symbols[name]

              return definition if definition
            end

            nil
          end
        end
      end
    end
  end
end
