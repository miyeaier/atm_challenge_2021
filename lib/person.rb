require "./lib/account.rb"
require "./lib/atm.rb"
require "pry"

class Person
  attr_accessor :name, :cash, :account

  def initialize(attrs = {})
    @name = set_name(attrs[:name])
    @cash = 0
    @account = nil
    #相应的是20行测试要有自己的账户
  end

  def create_account
    @account = Account.new(owner: self)
  end

  def deposit(amount)
    @account == nil ? missing_account : deposit_funds(amount) #
  end

  def withdraw(args = {})
    @account == nil ? missing_account : withdraw_funds(args)
  end

  private

  def withdraw_funds(args)
    #这个是指amount,pin_code,account,atm
    args[:atm] == nil ? missing_atm : atm = args[:atm]
    account = @account
    amount = args[:amount]
    pin = args[:pin]
    response = atm.withdraw(amount, pin, account)
    response[:status] == true ? increase_cash(response) : response
  end

  def increase_cash(response)
    @cash += response[:amount]
  end

  def set_name(name)
    name == nil ? missing_name : name
    #具体解释一下nil
  end

  def deposit_funds(amount)
    @cash -= amount
    #c -= a 相当于 c = c - a（账户的钱变少因为取出来了）
    @account.balance += amount
    #c += a 相当于 c = c + a（现金变多因为取钱了）
  end

  def missing_name
    raise RuntimeError, "A name is required"
  end

  def missing_account
    raise RuntimeError, "No account present"
  end

  def missing_atm
    raise RuntimeError, "An ATM is required"
  end
end
