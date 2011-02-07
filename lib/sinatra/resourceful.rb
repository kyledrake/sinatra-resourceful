require 'ostruct'
require 'linguistics'

module Sinatra
  module Resourceful
    def resource(model, *actions, &block)
      Resource.new self, model, actions, block
    end
    
    class Resource
      
      class Config < OpenStruct; end
      attr_reader :config
      
      ACTIONS = [:index, :new, :create, :show, :edit, :update, :delete]
      def initialize(app, model, actions, block)
        
        raise ArgumentError, 'action(s) must be Array, String, or Symbol' unless [Array, String, Symbol].include? actions.class
        
        if (actions.is_a?(Symbol) && actions == :all) || (actions.is_a?(Array) && actions == [:all])
          actions = ACTIONS
          actions = [*actions]
        end
        
        @model = model.name
        @singular = @model.downcase.to_sym        
        @plural = Linguistics::EN.plural(@model.downcase).to_sym
        
        self.instance_eval(&block) if block

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
        
        _c = @config
        
        if actions.include? :index
          app.get "/#{_c.plural}/?" do
            self.instance_eval &_c.before if _c.before_actions.include?(:index)
            self.instance_eval %{
              @#{_c.plural} = #{_c.model}.all _c.conditions
              erb "#{_c.plural}/index".to_sym
            }
          end
        end

        if actions.include? :new
          app.get "/#{_c.plural}/new" do
            self.instance_eval &_c.before if _c.before_actions.include?(:new)
            self.instance_eval %{
              erb "#{_c.plural}/new".to_sym
            }
          end
        end

        if actions.include? :create
          app.post "/#{_c.plural}" do
            self.instance_eval &_c.before if _c.before_actions.include?(:create)
            self.instance_eval %{
              @#{_c.plural} = #{_c.model}.create params[:#{_c.singular}]
              redirect _c.create_redirect
            }
          end
        end

        if actions.include? :update
          app.put "/#{_c.plural}/:id" do
            self.instance_eval &_c.before if _c.before_actions.include?(:update)
            self.instance_eval %{
              #{_c.singular} = #{_c.model}.get(params[:id]).update params[:#{_c.singular}]
              redirect _c.update_redirect
            }
          end
        end

        if actions.include? :edit
          app.get "/#{_c.plural}/:id/edit" do
            self.instance_eval &_c.before if _c.before_actions.include?(:edit)
            self.instance_eval %{
              @#{_c.singular} = #{_c.model}.get params[:id]
              erb :"#{_c.plural}/edit"
            }
          end
        end

        if actions.include? :show
          app.get "/#{_c.plural}/:id" do
            self.instance_eval &_c.before if _c.before_actions.include?(:show)
            self.instance_eval %{
              @#{_c.singular} = #{_c.model}.get params[:id]
              erb :"#{_c.plural}/show"
            }
          end
        end

        if actions.include? :delete
          app.delete "/#{_c.plural}/:id" do
            self.instance_eval &_c.before if _c.before_actions.include?(:delete)
            self.instance_eval %{
              #{_c.model}.get(params[:id]).destroy
              redirect "/#{_c.plural}"
            }
          end
        end
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