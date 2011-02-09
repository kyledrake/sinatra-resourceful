Sinatra::Resourceful
===

Sinatra::Resourceful is a tool for auto-generating routes for REST resources in Sinatra. It is based on my belief that using a fat models approach, Sinatra can be used to scale up to larger applications by eliminating the requirement to write a lot of redundant route code.

In addition to providing this functionality, it isolates route generation into modules so that you can easily write your own template, and then use that template for your specific application.

It is under active development, and things are subject to change. This message will go away when the project reaches a better level of stability.

Installation
---

    gem install sinatra-resourceful

General Usage (so far)
--- 
    class Widget
      property :id, Serial
      property :name, String
    end

    Sinatra::Resourceful.default_template = Sinatra::Resourceful::DataMapperTemplate
    class App < Sinatra::Base
      resource Widget, :index do
        conditions :name => '_why'
      end
    end

Want to Help?
---
E-Mail me and I'll add you as a collaborator. Or send pull requests.