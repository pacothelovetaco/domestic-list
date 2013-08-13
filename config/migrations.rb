
puts "the Transactions table doesn't exist" if !database.table_exists?('transactions')

# define database migrations. pending migrations are run at startup and
# are guaranteed to run exactly once per database.
migration "create the Transactions table" do
  database.create_table :transactions do
    primary_key :id
    String      :user
    String      :description
    Decimal	    :amount, :precision => 10, :scale => 2
    Decimal		:total, :precision => 10, :scale => 2
    String      :category
    timestamp   :created_at, :null => false

    index :user
  end
end