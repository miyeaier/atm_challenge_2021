require "./lib/account.rb"
describe Account do
  subject { Account.new }
  subject { described_class.new({ owner: person }) } #也修改subject主题里的内容为owner是个人

  let(:person) {
    instance_double("Person", name: "Miyesier") #给账户所有人定义单一属性
  }

  it "check the lenght of number" do
    number = 1234
    number_lenght = Math.log10(number).to_i + 1
    expect(number_lenght).to eq 4
  end

  it "is expected to have an expiry date on initialize" do #预计初始化有一个到期信息
    #这里我们设置卡的有效期默认为5年
    expected_date = Date.today.next_year(5).strftime("%m/%y")
    expect(subject.exp_date).to eq expected_date
  end

  it "is expected to have :active status on initialize" do #设置账户最初的时候这个账户就应该是:active状态
    expect(subject.account_status).to eq :active
  end

  it "is expected deactivates account using the class method" do
    Account.deactivate(subject)
    expect(subject.account_status).to eq :deactivated
  end

  it "is expected to have an owner" do #我们希望这里有个人
    expect(subject.owner).to eq person
  end

  it "is expected to raise error is no owner is set" do #没有设置所有人会发生错误
    expect { described_class.new }.to raise_error "An Account owner is required"
  end
end
