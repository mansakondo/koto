# frozen_string_literal: true

require "test_helper"

class KotoTest < Minitest::Test
  include TestHelper

  def test_that_it_has_a_version_number
    refute_nil ::Koto::VERSION
  end

  def test_it_does_something_useful
    scoped_constant = n(:const, [
      n(:const, [
        n(:const, [
          nil, :Parser
        ]),
        :AST
      ]),
      :Node
    ])

    unscoped_constant = n(:const, [
        nil, :"Parser::AST::Node"
      ])

    assert_equal unscoped_constant, processor.process(scoped_constant)

    p = processor

    ast = parse "class Context; private; def push; end; end"
    p.process(ast)

    c       = p.context
    symbols = c.symbols

    klass  = symbols[:Context]
    method = klass.symbols[:push]

    assert_equal :public, klass.access
    assert_equal :private, method.access
  end
end
