require 'date'
class Atm
  attr_accessor :funds
  
  def initialize
    @funds = 1000
  end

  def withdraw(amount,account) -> withdraw(amount, pin_code,account)
    case 
  
    when insufficient_funds_in_account?(amount,account)
      {status:false,
        message:'insufficient funds in account',
        date:Date.today
      }
    when insufficient_funds_in_atm?(amount)
      { status:false,
        message:'insufficient funds in ATM',
        date:Date.today
      }
    when incorrect_pin?(pin_code,account.pin_code)
          {status: false,
           message:'wrong pin',
           date:Date.today
          },
     when card_expired?(account.exp_date)
      {
        status: false,
        message:'card expored',
        date: Date.today
      }

      when card_disable?(account.account_status)
        {
          status:fales,
          message:'card disable',
          date:Date.today
        }
    else
      perform_transaction(amount,account)

    end
   end
   
   private
   
   def insufficient_funds_in_account?(amount,account)
    amount > account.balance
   end

   def insufficient_funds_in_account?(amount)
    @funds < amount
   end 

   def incorrect_pin?(pin_code,actual_pin)
    pin_code != actual_pin
   end

   def card_expired?(exp_data)
    Date.strptime(exp_date,'%m/%Y') <Date.today
   end

   def card_disable?(account_status)
    account == active
   end

   def perform_transaction(amount,account)
    @funds -= amount
    account.balance = account.balance - amount
    {
      status: true,
      message:'success',
      data:Data.today,
      amount:amount,
      bills: add_bills(amount)
    }
  end
  def add_bills(amount)
    denominations =[20,10,5]
    bills =[]
    denominations.each do |bill|
      while amount -bill >= 0
        amount -= bill
        bills << bill
      end
    end
    bills
  end

end