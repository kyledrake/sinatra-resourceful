Sinatra::Resourceful
===

Sinatra::Resourceful is a thought experiment: A tool for helping you to DRY up your REST routes using templates. Most applications have specific things required for their models that disallows for a generic REST route generation tool. The difference is that this one allows you to create your own.

The goal is to implement a simple, easy to use mechanism for cleaning up Sinatra applications by reducing the amount of code required to deal with routes for those that subscribe to the fat models MVC approach.

It is incomplete and everything here is subject to change.

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