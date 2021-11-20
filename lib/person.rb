require "date"

class Person
  attr_accessor :name, :cash, :account


def initialize (attrs = {})
  @name = set_name(attrs[:name])
  @cash=0
  @account=nil#相应的是20行测试要有自己的账户
end


  private

  def set_name(name)
    name == nil ? missing_name : name
  end 

  def missing_name
    raise RuntimeError, "A name is required"
  end
end