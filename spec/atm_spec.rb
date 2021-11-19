require "./lib/atm.rb"

describe Atm do
  subject { Atm.new }

  let (:account) {
    instance_double("Account", pin_code: "1234",
                               exp_date: "04/40", account_status: :active)
  }
  before do
    #为了让用户银行账户里有钱就添加100元的 :balance属性到(accout object)账户上
    allow(account).to receive(:balance).and_return(100)
    #把刚才定义的100存到用户的账户里
    allow(account).to receive(:balance=)
  end

  it "is expected to have $1000 when instantiated" do
    expect(subject.funds).to eq 1000
  end

  it "is expected to reduce funds on withdraw" do
    #降低金额就是1000元减去五十剩下950 密码是1234
    subject.withdraw 50, "1234", account
    expect(subject.funds).to eq 950
  end

  it "is expected to allow withdrawal if account has enough balance" do
    expected_output = {
      status: true,
      message: "success",
      date: Date.today,
      amount: 45,
      bills: [20, 20, 5],
    }
    expect(subject.withdraw(45, "1234", account)).to eq expected_output
  end

  # sad PAS
  #账户余额不足将拒绝取款
  it "is expected to reject an withdrawal if account has insufficient funds" do
    expected_output = {
      status: false,
      message: "insufficient funds in account",
      date: Date.today,
    } #我们上面allow 写了我们账户里有100，为了让写失败案例我们取了105
    expect(subject.withdraw(105, "1234", account)).to eq expected_output
  end

  it "reject withdraw if ATM has insufficient funds" do #钱不够情况在ATM
    subject.funds = 50 #atm里只有50
    expected_output = {
      status: false,
      message: "insufficient funds in ATM",
      date: Date.today,
    } #我们期待取100 但ATM里只有五十所以会失败
    expect(subject.withdraw(100, "1234", account)).to eq expected_output
  end

  it "reject withdraw if the pin is wrong " do
    expected_output = {
      status: false,
      message: "wrong pin",
      date: Date.today,
    }
    expect(subject.withdraw(50, 9999, account)).to eq expected_output
  end

  it "is expected to reject withdraw if the card is expired" do
    allow(account).to receive(:exp_date).and_return("12/15")
    expected_output = {
      status: false,
      message: "card expired",
      date: Date.today,

    }
    expect(subject.withdraw(5, "1234", account)).to eq expected_output
  end

  it "reject withdraw if the  account is disabled" do
    allow(account).to receive(:account_status).and_return(:disabled)
    expected_output = {
      status: false,
      message: "account disabled",
      date: Date.today,
    }
    expect(subject.withdraw(6, "1234", account)).to eq expected_output
  end
end
