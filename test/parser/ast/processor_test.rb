# frozen_string_literal: true

require 'test_helper'

class ProcessorTest < MiniTest::Test
  include TestHelper

  def test_should_convert_scoped_constants_to_unscoped_constants
    scoped_constant   = parse "Scoped::Constant"
    unscoped_constant = n(:const, [nil, :"Scoped::Constant"])
    assert_equal unscoped_constant, process(scoped_constant)
  end

  def test_should_assign_name_to_named_nodes
    node = parse "class Name; end"
    node = process node
    assert node.name
  end

  def test_context
    p = processor
    c = p.context
    assert c

    node = parse "module AST; class Context; def get_in(node); stack << node; end; end; end"
    node = p.process(node)
    assert c.symbols[:AST].context.top_level?

    node = parse "private; def method; end;"
    node = p.process(node)
    c = p.context
    assert_equal :private, c.access
  end

  def test_resolver
    p = processor

    node = parse "class Resolver; def resolve(node); end; end; Resolver"
    node = p.process(node)

    klass = node.children.first
    const = node.children.last
    _, _, value = *const

    assert_equal :class, value.type
    assert const == klass
  end
end
