require "date"
require "pry"

class Atm
  attr_accessor :funds

  def initialize
    @funds = 1000
  end

  def withdraw(amount, pin_code, account)
    #如果想要取钱就必须满足账户里的钱大于要取的钱所以我们要写一下code来说清楚什么情况下钱会取不成功else什么时候会成功
    case
    #CASE 子句可以用于任何表达式可以有效存在的地方。
    #SQL CASE 表达式是一种通用的条件表达式，类似于其它语言中的 if/else 语句。

    when insufficient_funds_in_account?(amount, account)
      {
        status: false,
        message: "insufficient funds in account",
        date: Date.today,
      }
    when insufficient_funds_in_ATM?(amount)
      {
        status: false,
        message: "insufficient funds in ATM",
        date: Date.today,
      }
    when incorrect_pin?(pin_code, account.pin_code)
      {
        status: false,
        message: "wrong pin",
        date: Date.today,
      }
    when card_expired?(account.exp_date)
      {
        status: false,
        message: "card expired",
        date: Date.today,
      }
    when account_disabled?(account.account_status)
      {
        status: false,
        message: "account disabled",
        date: Date.today,
      }
    else
      perform_transaction(amount, account)
    end
  end

  private

  #一下是以上的算法
  def insufficient_funds_in_account?(amount, account)
    #如果账户资金不足的情况是取的钱大于账户里的
    amount > account.balance
  end

  def insufficient_funds_in_ATM?(amount)
    #如果ATM资金不足是ATM总额小于账户
    @funds < amount
  end

  def perform_transaction(amount, account)
    #执行交易
    @funds -= amount
    #-=减且赋值运算符，把左操作数减去右操作数的结果赋值给左操作数 如：c -= a 相当于 c = c - a
    account.balance = account.balance - amount
    #这是正常操作上面表示atm里的钱减要取的金额旁边的意思是账户总额-要去的钱就会出以下的成功后的账单
    {
      status: true,
      message: "success",
      date: Date.today,
      amount: amount,
      bills: add_bills(amount),
    }
  end

  def incorrect_pin?(pin_code, actual_pin)
    pin_code != actual_pin
    #检查两个操作数的值是否相等，如果不相等则条件为真。(a != b) 为真。
  end

  def card_expired?(exp_date)
    #意思就是卡过期了是时间比我们之前定义的4/19要大就是比现在的日期大就是过期卡
    Date.strptime(exp_date, "%m/%y") < Date.today
  end

  def account_disabled?(account_status)
    account_status == :disabled
  end

  def add_bills(amount)
    denominations = [20, 10, 5]
    bills = []
    denominations.each do |bill|
      while amount - bill >= 0
        amount -= bill
        bills << bill
      end
    end
    bills
  end
end
