# frozen_string_literal: true

module Koto
  module Parser
    module AST
      class Processor < ::Parser::AST::Processor
        attr_reader :name_processor

        def initialize
          @name_processor = NameProcessor.new
        end

        def on_const(node)
          scope, name = *node

          if scope
            name = name_processor.process node
          end

          node.updated nil, [nil, name]
        end
      end
    end
  end
end
