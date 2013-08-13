ENV['RACK_ENV'] = 'test'

require 'minitest/autorun'
require 'rack/test'

require File.expand_path '../../app.rb', __FILE__
set :environment, :test

# Purge Test DB
transactions = Transaction.all
transactions.each do |t|
	t.destroy
end