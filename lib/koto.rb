# frozen_string_literal: true

require 'parser/current'

module Koto
  require "koto/version"

  module Parser
    module AST
      require 'koto/parser/ast/processor'
      require 'koto/parser/ast/processor/name_processor'
    end
  end
end
