testdir = File.dirname(__FILE__)
$LOAD_PATH.unshift testdir unless $LOAD_PATH.include?(testdir)
libdir = File.dirname(File.dirname(__FILE__)) + '/lib'
$LOAD_PATH.unshift libdir unless $LOAD_PATH.include?(libdir)

require 'test/unit'
require 'rack/test'
require 'contest'
require 'sinatra/base'
require 'sinatra/resourceful'

class Test::Unit::TestCase
  include Rack::Test::Methods
  
  def mock_app(base=Sinatra::Base, &block)
    base.register Sinatra::Resourceful
    @app = Sinatra.new(base, &block)
    @app.set :views, File.join('test', 'views')
    @app.set :show_exceptions, false
    @app.set :raise_errors, true
  end

  def app
    @app
  end

  def app=(new_app)
    @app = new_app
  end
  
end


class Widget
  
  DESCRIPTION = 'Some thing.'
  
  attr_accessor :description
  
  def initialize
    @description = DESCRIPTION
  end
  
  def self.all(args = {})
    args = {} if args.nil?
    return ['fancy'] if args && args[:is_not_an_idiot] == true
    []
  end
  
  def self.create(properties)
    true
  end
  
  def self.get(id)
    return (id == 'id' ? Widget.new : raise('Fail to lookup'))
  end
  
  def update(args)
    description = args[:description] if args[:description]
  end

  def destroy
    true
  end
  
end

class Brit < Widget
  def self.all(args = {})
    return ['fancybrit'] if args && args[:is_not_an_idiot] == true
  end
end

module TestTemplate
  def index
    _c = config
    'Template!'
  end
end


