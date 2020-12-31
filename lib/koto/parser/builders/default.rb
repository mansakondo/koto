# frozen_string_literal: true

module Koto
  module Parser
    class Builders::Default < ::Parser::Builders::Default
      def n(type, children, location)
        AST::Node.new(type, children, :location => location)
      end
    end
  end
end
