# frozen_string_literal: true

require 'parser/current'

module Koto
  require "koto/version"

  module Parser

    module AST
      require 'koto/parser/ast/node'
      require 'koto/parser/ast/processor'

      class Processor
        require "koto/parser/ast/processor/context"
        require 'koto/parser/ast/processor/name_processor'
      end
    end

    module Builders
      require "koto/parser/builders/default"
    end
  end
end
