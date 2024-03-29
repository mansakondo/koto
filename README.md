# koto    

(This project is still in prototype stage)<br><br>
*koto* is a Ruby symbol solver built on top of the [parser](https://github.com/whitequark/parser) gem. With it, we can resolve method calls, accesses to variables and constants (and maybe also inheritance relationships in the future).

koto traverses the [AST](https://github.com/whitequark/ast) of a given source code, stores nodes in a [symbol table for each scopes](https://en.wikipedia.org/wiki/Parent_pointer_tree#Use_in_compilers), and uses it to resolve references.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'koto'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install koto

## Usage

Loading *koto* :
```ruby
require 'koto'
```
Initializing the parser :
```ruby
builder = Koto::Parser::Builders::Default.new
parser  = Parser::CurrentRuby.new(builder)
```
Setting a source buffer :
```ruby
code   = "class Context; private; def push; pass; end; end"
buffer = Parser::Source::Buffer.new('(string)', source: code)
```
Processing data :
```ruby
ast = parser.parse(buffer)                                                                         

processor = Koto::Parser::AST::Processor.new
processor.process(ast)
```
Getting contextual information :
```ruby
context = processor.context                                                                                                  
symbols = context.symbols

klass  = symbols[:Context]                                                                                                   
method = klass.symbols[:push]    
    
p klass.access == :public 
# => true
p klass.context.top_level? 
# => true

p method.access == :private 
# => true
p method.context.in_class? 
# => true
```
Processing nested names :
```ruby                                                            
node = Parser::CurrentRuby.parse("Koto::Parser::AST::Processor::Resolver")

p node                               
# => s(:const,
#  s(:const,
#    s(:const,
#      s(:const,
#        s(:const, nil, :Koto), :Parser), :AST), :Processor), :Resolver)

processor = Koto::Parser::AST::Processor.new

p processor.process(node)
# => s(:const, nil, :"Koto::Parser::AST::Processor::Resolver")
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/koto.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
