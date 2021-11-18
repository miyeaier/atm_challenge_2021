require 'date'
class Account
  STANDARD_VALIDITY_YRS = 5

  attr_accessor :exp_date,:account_status,:pin_code,:balance

  def set_expire_date
  Date.today.next_year(Account::STANDARD_VALIDITY_YRS).strftime('%m/%y')
  end

  def initialize(attrs = {})
    @account_status =:active
    set_owner(attrs[:owner])
  
  def self.deactivate(account)
    account.account_status = :deactivated
  end
  private
  def set_owner(obj)
    obj == nil? missing_owner : @owner = obj
  end

  def missing_owner
    raise"An Account owner is required"
 end
end