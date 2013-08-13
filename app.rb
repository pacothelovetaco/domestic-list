require 'bundler/setup'
require "sinatra"
require 'sinatra/sequel'
require 'erb'
require './config/init'

# site#index
#
# get "/" do
#  "Hello Shithead"
# end

# transactions#index
#
get "/" do
  @user_one = Transaction::USERS.first
  @user_two = Transaction::USERS.last
  
  @transaction = Transaction.new
  @transactions = Transaction.all
  transaction_hash = @transactions.group_by(&:group_by_day)
  @grouped_transactions = Hash[transaction_hash.to_a.reverse]
  @total = Transaction.total
  erb :transactions_index
end


# transactions#new
#
# get '/transactions/new' do
#   @transaction = Transaction.new
#   erb :transaction_new
# end


# transactions#create
#
post "/transactions" do
	totals = Transaction.update_totals params
	#raise "#{params.merge(totals)}"
	Transaction.new(params.merge(totals)).save or halt 400
	redirect "/"
end

# transactions#show
#
# get '/people/:id' do
#   @person = Person[params[:id]] or halt 404
#   erb :people_show
# end

# transactions#edit
#
get '/transactions/:id/edit' do
  @transaction = Transaction[params[:id]] or halt 404
  @payee = @transaction.user
  @category = @transaction.category
  erb :transaction_edit, :layout => false
end


# transactions#update
#
put '/transactions/:id' do
  @transaction = Transaction[params[:id]] or halt 404
  totals = @transaction.edit_totals params
  @transaction.update(params) or halt 400
  redirect "/"
end

# transactions#destroy
#
delete '/transactions/:id' do
  @transaction = Transaction[params[:id]] or halt 404
  @transaction.delete_transaction
  redirect '/'
end
