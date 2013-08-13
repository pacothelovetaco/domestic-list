require 'sinatra/sequel'
require 'mysql'

set :environment, :production

#use Rack::MethodOverride

configure :production do
  set :database, 'mysql://user:pass@localhost/domestic_list'
end

configure :development do
  set :database, 'mysql://user:pass@localhost/domestic_list'
end

configure :test do
  set :database, 'mysql://user:pass@localhost/domestic_list_test'
end


require './config/migrations'

Sequel::Model.strict_param_setting = false
Dir["./models/**/*.rb"].each{|model|
  require model
}


helpers do
  include Rack::Utils
  alias_method :h, :escape_html
  
  # partial helper taken from Sam Elliot (aka lenary) at http://gist.github.com/119874 
  # which itself was based on Chris Schneider's implementation:
  # http://github.com/cschneid/irclogger/blob/master/lib/partials.rb
  def partial(template, *args)
    template_array = template.to_s.split('/')
    template = template_array[0..-2].join('/') + "/_#{template_array[-1]}"
    options = args.last.is_a?(Hash) ? args.pop : {}
    options.merge!(:layout => false)
    if collection = options.delete(:collection) then
      collection.inject([]) do |buffer, member|
        buffer << erb(:"#{template}", options.merge(:layout =>
        false, :locals => {template_array[-1].to_sym => member}))
      end.join("\n")
    else
      erb(:"#{template}", options)
    end
  end
end
