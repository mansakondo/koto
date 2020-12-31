# frozen_string_literal: true

module Koto
  module Parser
    module AST
      class Processor < ::Parser::AST::Processor
        attr_reader :name_processor
        attr_reader :required_files

        def name_processor
          @name_processor ||= NameProcessor.new
        end

        def required_files
          @required_files ||= []
        end

        # Methods from processing nodes

        def on_class(node)
          name, _ = *node

          name = name_processor.process(name)

          node.updated nil, [name, nil, nil],
            name: name
        end

        def on_const(node)
          scope, name = *node

          if scope
            name = name_processor.process node
          end

          node.updated nil, [nil, name],
            name: name
        end
      end
    end
  end
end
