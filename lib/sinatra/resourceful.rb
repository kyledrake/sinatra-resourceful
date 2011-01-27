require 'linguistics'

module Sinatra
  module Resourceful
    
    def resource(model, *actions, &block)
      Resource.new self, model, actions, block
    end
    
    class Resource
      
      def initialize(app, model, actions, block)
        
        raise ArgumentError, 'action(s) must be Array, String, or Symbol' unless [Array, String, Symbol].include? actions.class
        
        if (actions.is_a?(Symbol) && actions == :all) || (actions.is_a?(Array) && actions == [:all])
          actions = [:index, :new, :create, :show, :edit, :update, :delete]
          actions = [*actions]
        end
        
        model = model.name
        singular = model.downcase.to_sym
        plural = Linguistics::EN.plural(model.downcase).to_sym
        
        self.instance_eval(&block) if block

        redirect = @redirect || "/#{plural}"
        create_redirect = @create_redirect || redirect
        update_redirect = @update_redirect || redirect
        conditions = @conditions
        before = @before
        before_actions = @before_actions || []
        
        if actions.include? :index
          app.get "/#{plural}/?" do
            self.instance_eval &before if before_actions.include?(:index) || before_actions.include?(:all)
            instance_variable_set "@#{plural}", eval(model).send(:all, conditions)
            erb "#{plural}/index".to_sym
          end
        end

        if actions.include? :new
          app.get "/#{plural}/new" do
            self.instance_eval &before if before_actions.include?(:new) || before_actions.include?(:all)
            instance_variable_set "@#{plural}", eval(model).new
            erb "#{plural}/new".to_sym
          end
        end

        if actions.include? :create
          app.post "/#{plural}" do
            self.instance_eval &before if before_actions.include?(:create) || before_actions.include?(:all)
            instance_variable_set "@#{plural}", eval(model).send(:create, "params[:#{singular}]")
            redirect create_redirect
          end
        end

        if actions.include? :update
          app.put "/#{plural}/:id" do
            self.instance_eval &before if before_actions.include?(:update) || before_actions.include?(:all)
            eval "#{singular} = #{model}.get(params[:id]).update params[:#{singular}]"
            redirect update_redirect
          end
        end

        if actions.include? :edit
          app.get "/#{plural}/:id/edit" do
            self.instance_eval &before if before_actions.include?(:edit) || before_actions.include?(:all)
            eval "@#{singular} = #{model}.get params[:id]"
            erb "#{plural}/edit".to_sym
          end
        end

        if actions.include? :show
          app.get "/#{plural}/:id" do
            self.instance_eval &before if before_actions.include?(:show) || before_actions.include?(:all)
            eval "@#{singular} = #{model}.get params[:id]"
            erb "#{plural}/show".to_sym
          end
        end

        if actions.include? :delete
          app.delete "/#{plural}/:id" do
            self.instance_eval &before if before_actions.include?(:delete) || before_actions.include?(:all)
            eval "#{model}.get(params[:id]).destroy"
            redirect "/#{plural}"
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