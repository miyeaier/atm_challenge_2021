require "date"
require "pry"

class Account
  STANDARD_VALIDITY_YRS = 5
  attr_accessor :exp_date, :account_status, :balance, :pin_code, :balance, :owner #我们需要设定每一个我们用的method 在这里然后用不然就用不了

  def initialize(attrs = {}) #attrs 是指属性
    @account_status = :active #账户属性是活跃
    set_owner(attrs[:owner])
    @exp_date = set_expire_date() #要先引进前面测试中exp_data（）这个methed后才能在这里运用不然会找不到
  end

  def self.deactivate(account) #如果我们想停用一个帐户就选择class method 因为这是对整个账户下命令不是某一部分
    account.account_status = :deactivated
  end

  private

  def set_expire_date
    Date.today.next_year(STANDARD_VALIDITY_YRS).strftime("%m/%y")
  end

  def set_owner(obj)
    obj == nil ? missing_owner : @owner = obj
  end

  def missing_owner
    raise "An Account owner is required"
  end
end
