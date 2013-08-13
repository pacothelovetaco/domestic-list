# Domestic List : A for keeping track of all your domestic purchases.
#
# Copyright (c) 2013 Justin Leavitt jusleavitt@gmail.com
#
# This program is free software

require 'bigdecimal'

class Transaction < Sequel::Model 
  
  USERS = ["Michelle", "Justin"]
  CATEGORIES = ["Resturant", "Bar", "Groceries", "Supplies"]

  
  # Calculates the total whenever a new transaction is created.
  #
  # @author Justin Leavitt
  # @param params [Hash] the `:user`, and `:amount` of the new transaction. 
  # @return [Hash] the total parameter for the new transaction.
  def self.update_totals params
    current_user      = params[:user]
    current_amount    = BigDecimal.new(params[:amount].to_s)
    last_transaction  = self.last ? self.last.total : BigDecimal.new("0.00")

    case current_user 
    when USERS.first
      total = last_transaction + current_amount
    when USERS.last
      total = last_transaction - current_amount
    end
    {:total => total}
  end


  # Returns the current total from the last transaction. It is used
  # to display the current amount owed by the user.
  #
  # @author Justin Leavitt
  # @return [Numeric] current total from the last transaction
  def self.total
    return 0.0 if !self.last
    query = self.last
    query[:total].to_f
  end



  # Edits the total whenever a transaction is updated.
  #
  # @author Justin Leavitt
  # @param params [Hash] the `:user`, and `:amount` of the transaction. 
  def edit_totals params
    current_user      = params[:user]
    new_amount        = BigDecimal.new(params[:amount].to_s)
    last_transaction  = Transaction.last

    
    # If the user is not being updated, then
    # only the new amount is calculated and updated.
    if current_user == self.user
      difference = self.amount - new_amount
      case current_user 
      when USERS.first
        total = last_transaction.total - difference
      when USERS.last
        total = last_transaction.total + difference
      end
      last_transaction.update({:total => total})
    end

    # If the user is being updated, then
    # the changed amount must be updated against
    # the other user.
    if current_user != self.user
      difference = new_amount + self.amount
      case current_user 
      when USERS.first
        total = last_transaction.total + difference
      when USERS.last
        total = last_transaction.total - difference
      end
      last_transaction.update({:total => total})
    end
  end

  # Deletes and updates the total whenever a transaction is deleted.
  #
  # @author Justin Leavitt
  def delete_transaction 
    current_user = self.user
    transactions = Transaction.all

    # Current transaction is the only transaction, delete.
    if transactions.count <= 1
      self.delete
    else
      # Get the last transaction and update the total.
      last_transaction = Transaction.last
      
      case current_user 
      when USERS.first
        new_total = last_transaction.total - self.amount
      when USERS.last
        new_total = last_transaction.total + self.amount
      end
      
      # If the last transation is the last transaction,
      # edit the total for the second to last transaction.
      if self == transactions[-1]
        second_to_last_transaction = transactions[-2]
        second_to_last_transaction.update({:total => new_total})
      else 
        last_transaction.update({:total => new_total})
      end
      self.delete
    end
  end

  # Group transactions by creation date.
  #
  # @author Justin Leavitt
  # @return [Date] a transaction's created_at date.
  def group_by_day
    created_at.to_date
  end
end

