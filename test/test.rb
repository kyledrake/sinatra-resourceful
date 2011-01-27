require 'test/helper'

class AppTests < Test::Unit::TestCase
  
  context 'the resource method' do
    test 'raises ArgumentError unless action is String, Symbol or Array' do
      assert_raises ArgumentError, NoMethodError do
        mock_app { resource(:widgets, {:fuck => 'you'}) }
      end
    end
    
    test 'loads index route' do
      mock_app { resource Widget, :index }
      get '/widgets'
      assert last_response.ok?
      assert last_response.body =~ /Index!/
    end
    
    test 'loads new route' do
      mock_app { resource Widget, :new }
      get '/widgets/new'
      assert last_response.ok?
      assert last_response.body == 'New'
    end
    
    test 'loads create route' do
      mock_app { resource Widget, :create }
      post '/widgets'
      assert last_response.redirect?
      assert last_response.headers['Location'] =~ /\/widgets$/
    end
    
    test 'loads edit route' do
      mock_app { resource Widget, :edit }
      get '/widgets/id/edit'
      assert last_response.ok?
      assert last_response.body == "Edit #{Widget::DESCRIPTION}"
    end
    
    test 'loads update route' do
      mock_app { resource Widget, :update }
      put '/widgets/id', {:widget => {:test => 'works'}}
      assert last_response.redirect?
      assert last_response.headers['Location'] =~ /\/widgets/
    end
    
    test 'loads show route' do
      mock_app { resource Widget, :show }
      get '/widgets/id'
      assert last_response.ok?
      assert last_response.body == "Show #{Widget::DESCRIPTION}"
    end
    
    test 'loads all routes' do
      mock_app { resource Widget, :all }
      get '/widgets'
      assert last_response.body =~ /Index/
      get '/widgets/new'
      assert last_response.body =~ /New/
      get '/widgets/id/edit'
      assert last_response.body =~ /Edit/
      get '/widgets/id'
      assert last_response.body =~ /Show/
      post '/widgets'
      assert last_response.redirect?
      put '/widgets/id', {:widget => {:test => 'works'}}
      assert last_response.redirect?
      delete '/widgets/id'
      assert last_response.redirect?
    end
  end
  
  test 'uses specified conditions' do
    mock_app do
      resource Widget, :all do
        conditions :is_not_an_idiot => true
      end
    end
    get '/widgets'
    assert last_response.body =~ /fancy/
  end
  
  test 'uses alternative create redirect route' do
    mock_app do
      resource Widget, :create do
        create_redirect '/something/else'
      end
    end
    post '/widgets'
    assert last_response.redirect?
    assert last_response.headers['Location'] =~ /\/something\/else$/
  end
  
  test 'uses alternative update redirect route' do
    mock_app do
      resource Widget, :update do
        update_redirect '/new/update'
      end
    end
    put '/widgets/id', {:widget => {:test => 'works'}}
    assert last_response.redirect?
    assert last_response.headers['Location'] =~ /\/new\/update$/
  end
  
  test 'updates create and update redirect' do
    mock_app do
      resource Widget, :all do
        redirect "/strange/route"
      end
    end
    post '/widgets'
    assert last_response.redirect?
    assert last_response.headers['Location'] =~ /\/strange\/route$/
    put '/widgets/id', {:widget => {:test => 'works'}}
    assert last_response.redirect?
    assert last_response.headers['Location'] =~ /\/strange\/route$/
  end
  
  test 'resource actions can be array' do
    mock_app do
      resource Widget, :create, :update
    end
    
    assert true
  end
 
  test 'two resources work simultaneously' do
    mock_app do
      resource Widget, :all do
        conditions :is_not_an_idiot => true
      end
      resource Brit, :all do
        conditions :is_not_an_idiot => true
      end
    end
    
    get '/widgets'
    assert last_response.ok?
    assert last_response.body =~ /fancy/
    get '/brits'
    assert last_response.body =~ /fancybrit/
  end
 
  context 'before_model block' do
    setup do
      mock_app do
        resource Widget, :all do
          before(:all) { content_type 'text/xml' }
        end
      end
    end
    
    test 'works for index' do
      get '/widgets'
      assert last_response.headers['Content-Type'] =~ /^text\/xml/
    end
  end
  
=begin
  test 'after block works' do
    mock_app do
      resource Widget, :index do
        after do
          @widgets = ['notfancy']
        end
      end
    end
    get '/widgets'
   assert last_response.body =~ /notfancy/
  end
=end
  test 'sanity' do
    mock_app do
      get('/') { 'Hello' }
    end
    get '/'
    assert last_response.ok?
    assert last_response.body == 'Hello'
  end
  
end