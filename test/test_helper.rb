# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "koto"

require "minitest/autorun"

module TestHelper
  Parser = ::Parser::CurrentRuby

  def n(type, children)
    ::Parser::AST::Node.new(type, children)
  end

  def processor
    Koto::Parser::AST::Processor.new
  end

  def name_processor
    Koto::Parser::AST::NameProcessor.new
  end
end
