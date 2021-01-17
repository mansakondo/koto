# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "koto"

require "minitest/autorun"

module TestHelper

  CODE = "class Context; private; def push; pass; end; end";

  def parser
    builder = Koto::Parser::Builders::Default.new
    ::Parser::CurrentRuby.new(builder)
  end

  def parse(source)
    buffer = ::Parser::Source::Buffer.new('(string)', :source => source)
    parser.parse(buffer)
  end

  def n(type, children)
    Koto::Parser::AST::Node.new(type, children)
  end

  def processor
    Koto::Parser::AST::Processor.new
  end

  def process(node)
    processor.process(node)
  end

  def context
    Koto::Parser::AST::Processor::Context.new
  end

  def symbol_table
    Koto::Parser::AST::Processor::Context::SymbolTable.new
  end

  def name_processor
    Koto::Parser::AST::Processor::NameProcessor.new
  end
end
