spec = Gem::Specification.new do |s|
  s.name = 'sinatra-resourceful'
  s.version = '0.0.1'
  s.summary = "Resourceful routes for Sinatra."
  s.description = %{Sinatra::Resourceful allows for incredibly terse route definitions in Sinatra for those that subscribe to the fat models style of development.}
  s.files = Dir['lib/**/*.rb'] + Dir['test/**/*.rb']
  s.require_path = 'lib'
#  s.has_rdoc = false
#  s.rubyforge_project = 'sinatra-resourceful'
#  s.extra_rdoc_files = Dir['[A-Z]*']
#  s.rdoc_options << '--title' << 'Sinatra::Resourceful -- Description Here'
  s.author = "Kyle Drake"
  s.email = "kyledrake@gmail.com"
  s.homepage = "http://github.com/kyledrake/sinatra-resourceful"
  s.requirements << 'sinatra, v1.0 or greater'
  s.add_dependency 'sinatra', '>= 1.0'
  s.add_dependency 'linguistics', '1.0.8'
end