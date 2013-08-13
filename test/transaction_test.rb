require File.expand_path '../test_helper.rb', __FILE__

class MyTest < MiniTest::Unit::TestCase

  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  def setup
  	@user1 = Transaction::USERS.first
  	@user2 = Transaction::USERS.last
  end

  # def test_hello_world
  #   get '/'
  #   assert last_response.ok?
  #   assert_equal "Hello, World!", last_response.body
  # end

  # Transactions#create

  def test_can_create_transaction
  	skip "Waiting until I can find a good way to test this."
    post '/transactions', user: @user1, amount: "0"
  	#assert Transaction.count > 0
    assert last_response.ok?
    assert_equal 'Hello Bryan', last_response.body
  end

  
  def test_update_totals_when_first_user_creates_transaction 
  	# Create Transaction for testing
  	Transaction.create(user: @user2, amount: "5", total: "-5")
  	
  	params = {user: @user1, amount: "5"}
  	
  	# Update totals
  	totals = Transaction.update_totals params
		Transaction.new(params.merge(totals)).save
		
		# Get newly created transaction
		transaction = Transaction.last
  	assert_equal 0, transaction.total.to_f
  	assert_equal @user1, transaction.user
  end

  
  def test_update_totals_when_second_user_creates_transaction 
  	# Create Transaction for testing
  	Transaction.create(user: @user1, amount: "5", total: "5")
  	
  	params = {user: @user2, amount: "5"}
  	
  	# Update totals
  	totals = Transaction.update_totals params
		Transaction.new(params.merge(totals)).save
		
		# Get newly created transaction
		transaction = Transaction.last
  	assert_equal 0, transaction.total.to_f
  	assert_equal @user2, transaction.user
  end

  #
  # Transactions#update
  #

  def test_edit_totals_when_first_user_edits_transaction
  	transaction = Transaction.create(user: @user1, amount: "5", total: "5")
  	
  	put "/transactions/#{transaction.id}", user: @user1 , amount: "10"
  	updated_transaction = Transaction.last
  	assert_equal 10, updated_transaction.amount.to_f
  	assert_equal 10, updated_transaction.total.to_f
  end

  
  def test_edit_totals_when_second_user_edits_transaction
  	transaction = Transaction.create(user: @user2, amount: "5", total: "-5")
  	
  	put "/transactions/#{transaction.id}", user: @user2 , amount: "10"
  	updated_transaction = Transaction.last
  	assert_equal 10, updated_transaction.amount.to_f
  	assert_equal -10, updated_transaction.total.to_f
  end


  def test_edit_totals_when_switching_users
  	transaction = Transaction.create(user: @user2, amount: "5", total: "-5")
  	
  	put "/transactions/#{transaction.id}", user: @user1 , amount: "5"
  	updated_transaction = Transaction.last
  	assert_equal 5, updated_transaction.amount.to_f
  	assert_equal 5, updated_transaction.total.to_f
  end

  #
  # Transactions#delete
  #

  def test_can_delete_transaction
    skip "Waiting until I can find a good way to test this."
  end

  def test_delete_updates_total_for_first_user
    transaction1 = Transaction.create(user: @user1, amount: "10", total: "10")
    transaction2 = Transaction.create(user: @user2, amount: "5", total: "5")
    
    delete "/transactions/#{transaction1.id}"
    updated_transaction = Transaction.last
    assert_equal -5, updated_transaction.total.to_f
  end

  def test_delete_updates_total_for_second_user
    transaction1 = Transaction.create(user: @user2, amount: "10", total: "-10")
    transaction2 = Transaction.create(user: @user1, amount: "5", total: "-5")
    
    delete "/transactions/#{transaction1.id}"
    updated_transaction = Transaction.last
    assert_equal 5, updated_transaction.total.to_f
  end

end