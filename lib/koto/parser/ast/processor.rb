# frozen_string_literal: true

module Koto
  module Parser
    module AST
      class Processor < ::Parser::AST::Processor

        OBJECT_METHODS = [
          *Object.methods
        ]

        KERNEL_METHODS = [
          *(Kernel.methods - OBJECT_METHODS)
        ]

        ACCESS_METHODS = [
          :private,
          :protected,
          :public,
        ]

        MODULE_METHODS = [
          *(Module.methods - OBJECT_METHODS)
        ]

        PREDEFINED_METHODS = [
          *OBJECT_METHODS,
          *KERNEL_METHODS,
          *ACCESS_METHODS,
          *MODULE_METHODS
        ]

        BUILTIN_TYPES = [
          *Object.constants
        ]

        attr_reader :context

        def initialize
          @context = Context.new
        end

        def name_processor
          @name_processor ||= NameProcessor.new
        end

        def required_files
          @required_files ||= []
        end

        # Methods for processing nodes

        def on_class(node)
          name, superclass, body = *node

          name       = name_processor.process(name)
          superclass = process superclass

          node = node.updated nil, [name, superclass, body],
            name: name

          context.get_in node

          node = node.updated nil, [name, superclass, process(body)],
            name: name

          context.get_out node
        end

        def on_module(node)
          name, body = *node

          name = name_processor.process(name)

          node = node.updated nil, [name, body],
            name: name

          context.get_in node

          node = node.updated nil, [name, process(body)],
            name: name

          context.get_out node
        end

        def on_def(node)
          name, args, body = *node

          args = process_all(args)

          node = node.updated nil, [name, *args, body],
            name: name

          context.get_in node

          node = node.updated nil, [name, *args, process(body)],
            name: name

          context.get_out node
        end

        def on_const(node)
          scope, name = *node

          if scope
            name = name_processor.process(node)
          end

          node.updated nil, [nil, name],
            name: name
        end

        def on_send(node)
          _, name, _ = *node

          # Invokes specific handlers for predefined methods
          if PREDEFINED_METHODS.include? name
            on_method = :"on_#{name}"

            if respond_to? on_method
              node = node.updated :"#{name}", node.children
              return send on_method, node
            else
              return handler_missing(node)
            end
          end

          node.updated nil, [nil, name],
            name: name

          super
        end

        # @private
        def on_access(node)
          access = node.type
          context.switch_access_to access
        end

        alias on_private on_access
        alias on_protected on_access
        alias on_public on_access
      end
    end
  end
end
