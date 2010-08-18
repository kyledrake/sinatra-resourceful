recipe :default do
  
  get "/PLURAL/?" do
    @PLURAL = MODEL.all ARGUMENTS
    erb :'PLURAL/index'
  end
  
  get '/PLURAL/new' do
    @SINGULAR = MODEL.new
    erb :'PLURAL/new'
  end
  
  get '/PLURAL/:id/edit' do
    @SINGULAR = MODEL.get params[:id]
    erb :'PLURAL/edit'
  end
  
  get '/PLURAL/:id' do
    @SINGULAR = MODEL.first params[:id]
    erb :'PLURAL/show'
  end
  
  post '/PLURAL' do
    @SINGULAR = MODEL.new params[:SINGULAR]
    @SINGULAR.valid? ? @SINGULAR.save : erb(:'PLURAL/new')
    redirect "/PLURAL/#{@SINGULAR.id}"
  end
  
  put '/PLURAL/:id' do
    @SINGULAR = MODEL.get params[:id]
    @SINGULAR.update(params[:SINGULAR]) ? redirect('/PLURAL') : erb(:'PLURAL/edit')
  end
  
  delete '/PLURAL/:id' do
    @SINGULAR = MODEL.get params[:id]
    @SINGULAR.destroy
    redirect '/PLURAL'
  end
  
end