# koto    

*koto* is a Ruby symbol solver built on top of the [*parser*](https://github.com/whitequark/parser) gem. We it, we can resolves references like method calls, accesses to variables, inheritance relationships and more.

koto traverses the [AST](https://github.com/whitequark/ast) of a given source code, stores nodes in a [symbol table for each scopes](https://en.wikipedia.org/wiki/Parent_pointer_tree#Use_in_compilers) and uses it to resolve references.

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

Load *koto*.
```ruby
require 'koto'
```
An code example with <code>Koto::Parser::AST::Processor</code> which extends <code>Parser::AST::Processor</code>.
```ruby                                                            
node = Parser::CurrentRuby.parse("Koto::Parser::AST::Processor::Resolver")      
                                     
p node                               
# (const                        
#   (const  
#     (const   
#       (const     
#         (const     
#           nil                                                                                                                                 
#           :Koto)                                                                                                                                 
#         :Parser)                                                                                                                              
#       :AST)                                                                                                                              
#     :Processor)                                                                                                                             
#   :Resolver)                                                                                                                                
                                                                                                                                              
processor = Koto::Parser::AST::Processor.new                                                                                        
                                                                                                                                              
p processor.process(node)
# (const
#   nil 
#   :Koto::Parser::Processor::Resolver)
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/koto.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
