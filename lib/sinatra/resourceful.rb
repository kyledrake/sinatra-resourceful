require 'ostruct'
require 'linguistics'
require 'lib/sinatra/datamapper' # DELETE THIS, SEND THROUGH DSL

module Sinatra
  module Resourceful
    def resource(model, *actions, &block)
      Resource.new self, model, actions, block
    end
    
    class Resource
      
      include DataMapperTemplate
      
      class Config < OpenStruct; end
      attr_reader :config, :app
      
      ACTIONS = [:index, :new, :create, :show, :edit, :update, :delete]
      def initialize(app, model, actions, block)
        
        raise ArgumentError, 'action(s) must be Array, String, or Symbol' unless [Array, String, Symbol].include? actions.class
        
        if (actions.is_a?(Symbol) && actions == :all) || (actions.is_a?(Array) && actions == [:all])
          actions = ACTIONS
        end
        
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
        
        # Containerize these with an OpenStruct, so we can bind them to a local variable for the block execution.
        # The alternative is something crazy that writes local variables from instance variables.. not interested.
        @config = Config.new :model => @model,
                             :singular => @singular,
                             :plural => @plural,
                             :redirect => @redirect, 
                             :create_redirect => @create_redirect, 
                             :update_redirect => @update_redirect, 
                             :conditions => @conditions,
                             :before => @before,
                             :before_actions => @before_actions
        
        actions.each {|action| send(action.to_sym)}
      end
      
      def before(*actions, &block)
        actions << :all if actions.empty?
        @before_actions = actions
        @before = block
      end
      
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