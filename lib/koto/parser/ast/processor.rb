# frozen_string_literal: true

module Koto
  module Parser
    module AST
      class Processor < ::Parser::AST::Processor

        OBJECT_METHODS = [
          *(Object.methods - [:class])
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

        def switch_context_to(context)
          @context = context
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

          node =
            node.updated nil,
            [name, superclass, body],
            :name => name

          access          = context.access
          current_context = context.get_in(node)

          switch_context_to current_context

          node =
            node.updated nil,
            [name, superclass, process(body)],
            :name => name

          symbols, current_context = context.get_out

          current_context =
            current_context.switch_access_to access

          node =
            node.updated :casgn,
            [nil, name, node],
            :name => name, :context => current_context, :symbols => symbols

          current_context = current_context.save(node)

          switch_context_to current_context

          node
        end

        def on_module(node)
          name, body = *node

          name = name_processor.process(name)

          node =
            node.updated nil,
            [name, body],
            :name => name

          access          = context.access
          current_context = context.get_in(node)

          switch_context_to current_context

          node =
            node.updated nil,
            [name, process(body)],
            :name => name

          symbols, current_context = context.get_out

          current_context =
            current_context.switch_access_to access

          node =
            node.updated :casgn,
            [nil, name, node],
            :name => name, :context => current_context, :symbols => symbols

          current_context = current_context.save(node)

          switch_context_to current_context

          node
        end

        def on_def(node)
          name, args, body = *node

          args = process_all(args)

          node =
            node.updated nil,
            [name, *args, body],
            :name => name

          access          = context.access
          current_context = context.get_in(node)

          switch_context_to current_context

          node =
            node.updated nil,
            [name, *args, (body = process(body))],
            :name => name

          symbols, current_context = context.get_out

          current_context =
            current_context.switch_access_to access

          node =
            node.updated nil,
            [name, *args, body],
            :name => name, :context => current_context, :symbols => symbols

          current_context = current_context.save(node)

          switch_context_to current_context

          node
        end

        def on_const(node)
          scope, name = *node

          if scope
            name = name_processor.process(node)
          end

          node.updated nil,
            [nil, name],
            :name => name
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

          node.updated nil,
            [nil, name],
            :name => name

          super
        end

        def on_access(node)
          access          = node.type
          current_context = context.switch_access_to access

          switch_context_to current_context
        end

        alias on_private on_access
        alias on_protected on_access
        alias on_public on_access
      end
    end
  end
end
