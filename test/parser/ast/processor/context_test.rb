# frozen_string_literal: true

require "test_helper"

class ContextTest < Minitest::Test
  include TestHelper

  def test_should_save_nodes
    p = processor

    node = parse "module AST; end"
    node = p.process(node)

    c = p.context

    assert c.symbols[:AST]
  end

  def test_parent_scope
    c = context
    assert c.top_level?

    mod = parse "module AST; end"
    a = c.get_in(mod)
    assert a.in_module?
    assert c.top_level?

    klass = parse "class Context; end"
    b = a.get_in(klass)
    assert b.in_class?
    assert c.top_level?

    method = parse "def get_in(node); end"
    d = b.get_in(method)
    assert d.in_def?
    assert c.top_level?
  end

  def test_access
    c = context
    a = c.switch_access_to :private
    assert_equal :private, a.access
    assert_equal :public, c.access
  end

  def test_each
    node = parse CODE

    p = processor
    p.process(node)

    c = p.context
    assert c.each

    c.each do |scope|
      symbols = scope.data
      assert symbols
    end
  end
end
