module Sinatra
  module Resourceful
    module DataMapperTemplate
      def index
        _c = config
        app.get "/#{_c.plural}/?" do
          self.instance_eval &_c.before if _c.before_actions.include?(:index)
          self.instance_eval %{
            @#{_c.plural} = #{_c.model}.all _c.conditions
            erb "#{_c.plural}/index".to_sym
          }
        end
      end

      def new
        _c = config
        app.get "/#{_c.plural}/new" do
          self.instance_eval &_c.before if _c.before_actions.include?(:new)
          self.instance_eval %{
            erb "#{_c.plural}/new".to_sym
          }
        end    
      end
  
      def create
        _c = config
        app.post "/#{_c.plural}" do
          self.instance_eval &_c.before if _c.before_actions.include?(:create)
          self.instance_eval %{
            @#{_c.plural} = #{_c.model}.create params[:#{_c.singular}]
            redirect _c.create_redirect
          }
        end
      end
  
      def update
        _c = config
        app.put "/#{_c.plural}/:id" do
          self.instance_eval &_c.before if _c.before_actions.include?(:update)
          self.instance_eval %{
            #{_c.singular} = #{_c.model}.get(params[:id]).update params[:#{_c.singular}]
            redirect _c.update_redirect
          }
        end
      end
  
      def edit
        _c = config
        app.get "/#{_c.plural}/:id/edit" do
          self.instance_eval &_c.before if _c.before_actions.include?(:edit)
          self.instance_eval %{
            @#{_c.singular} = #{_c.model}.get params[:id]
            erb :"#{_c.plural}/edit"
          }
        end
      end
  
      def show
        _c = config
        app.get "/#{_c.plural}/:id" do
          self.instance_eval &_c.before if _c.before_actions.include?(:show)
          self.instance_eval %{
            @#{_c.singular} = #{_c.model}.get params[:id]
            erb :"#{_c.plural}/show"
          }
        end
      end
  
      def delete
        _c = config
        app.delete "/#{_c.plural}/:id" do
          self.instance_eval &_c.before if _c.before_actions.include?(:delete)
          self.instance_eval %{
            #{_c.model}.get(params[:id]).destroy
            redirect "/#{_c.plural}"
          }
        end
      end
    end
  end
end