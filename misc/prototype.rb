
# DSL Thoughts...

Sinatra::Resource.create_redirect_default :one
Sinatra::Resource.update_redirect_default :all
Sinatra::Resource.update_redirect_default "/#{Sinatra::Resource::MODEL}/#{Sinatra::Resource::IDENTIFIER}"

resource :post, :new, :create do
  create_redirect "/posts/#{post.id}"
  update_redirect "/posts/#{post.id}"
  redirect "/posts/#{post.id}"
  
  before do
    puts "code to execute before route!"
  end
  
  after do
    puts "executed just before redirect and/or render"
  end
  
  conditions :is_not_idiot => true
  slug :slug
end