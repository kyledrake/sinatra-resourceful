require 'ostruct'
require 'linguistics'

module Sinatra
  module Resourceful
    def resource(model, *actions, &block)
      Resource.new self, model, actions, block
    end
    
    @@default_template = nil
    def self.default_template; @@default_template end
    def self.default_template=(mod); @@default_template = mod end
    
    class Resource
      
      ACTIONS = [:index, :new, :create, :show, :edit, :update, :delete]
      
      class Config < OpenStruct; end
      attr_reader :app
      
      # Containerize these with an OpenStruct, so we can bind them to a local variable for the block execution.
      # The alternative is something crazy that writes local variables from instance variables.. not interested.
      def config; @config = Config.new Hash[instance_variables.map {|k| [k[1..k.length].to_sym, eval(k)] }] end
      
      def initialize(app, model, actions, block)
        
        raise ArgumentError, 'action(s) must be Array, String, or Symbol' unless [Array, String, Symbol].include? actions.class
        
        actions = ACTIONS if (actions.is_a?(Symbol) && actions == :all) || (actions.is_a?(Array) && actions == [:all])
        
        self.instance_eval(&block) if block

        @app = app
        @model = model.name
        @singular = @model.downcase.to_sym        
        @plural = Linguistics::EN.plural(@model.downcase).to_sym
        @redirect ||= "/#{@plural}"
        @create_redirect ||= @redirect
        @update_redirect ||= @redirect
        @before_actions ||= []
        @before_actions = ACTIONS if @before_actions.include?(:all)
        @actions = actions
        @template ||= Sinatra::Resourceful.default_template
        extend @template
    
        @actions.each {|action| send(action.to_sym)}
      end
      
      def before(*actions, &block); @before_actions = (actions.empty? ? [:all] : actions) and @before = block end
      def template(mod); @template = mod end
      def conditions(opts={}); @conditions = opts end
      def create_redirect(url); @create_redirect = url end
      def update_redirect(url); @update_redirect = url end
      def redirect(url); @redirect = url end
    end

    def self.registered(app)
    end
    
  end
  
  register Resourceful
end