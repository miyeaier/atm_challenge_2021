require "./lib/person.rb"
require "./lib/atm.rb"

#每个账号都该有一个人持有 以下是持有人的条件
describe Person do
  subject { described_class.new(name: "Miyesier") }

  it "is expected to have a :name on initialize" do
    expect(subject.name).not_to be nil
    expect(subject.name).to eq "Miyesier"
  end

  it "is expected to raise an error if no name is set" do
    #如果没有名字就显示出错
    expect { described_class.new }.to raise_error(RuntimeError, "A name is required")
    #expect { subject.deposit(100) }.to raise_error(RuntimeError, "No account present")
  end

  it "is expected to have a :cash attribute with the value of 0 on initialize" do
    #在持卡人刚拥有卡的时候确保卡里没钱
    expect(subject.cash).to eq 0
  end

  it "is expected to have a :account attribute" do
    #拥有卡的持有人也要有卡相应的账户
    expect(subject.account).to be nil
    #nil： 判断对象是否存在（nil）。不存在的对象都是nil的。
  end

  describe "can create an Account" do
    #可以创建账户
    before { subject.create_account }
    #subject 你看上面的code已经定义了

    it "of Account class " do
      #之前我们创建了Account class在别的文件夹里这里表示我们现在创建的账户属于我们之前创建的Accountclass里的一个实例
      expect(subject.account).to be_an_instance_of Account
    end

    it "with herself as an owner" do
      #意思是我们账户持有人就是我们上面创建的subject里的那个人
      expect(subject.account.owner).to be subject
    end
  end

  describe "can manage funds if an account been created" do
    #当你创建了一个账户后你可以管理你的钱了
    let(:atm) { Atm.new }
    before { subject.create_account }
    #首先你成功建立了账户

    it "can deposit funds" do
      #之后就可以开始存钱了
      expect(subject.deposit(100)).to be_truthy
      # 你存进去一百的这个事实被接受了（存100是真的）
    end

    it "funds are added to the account balance - deducted from cash" do #资金被添加到账户余额 - 从现金中扣除
      subject.cash = 100
      subject.deposit(100)
      expect(subject.account.balance).to be 100
      expect(subject.cash).to be 0
    end

    it "can withdraw fund" do
      #什么是lamba？！！
      command = lambda { subject.withdraw(amount: 100, pin: subject.account.pin_code, account: subject.account, atm: atm) }
      expect(command.call).to be_truthy
    end

    it "withdraw is expected to raise an error if no ATM is passed in" do
      #这里的ATM 指的是method
      command = lambda { subject.withdraw(amount: 100, pin: subject.account.pin_code, account: subject.account) }
      expect { command.call }.to raise_error "An ATM is required"
    end

    it "fund are added to cash -deducted from account balance" do
      #资金添加到现金 - 从账户余额中扣除
      subject.cash = 100
      subject.deposit(100)
      subject.withdraw(amount: 100, pin: subject.account.pin_code, account: subject.account, atm: atm)
      expect(subject.account.balance).to be 0
      expect(subject.cash).to be 100
    end
  end

  describe "can not manage funds if no account been created" do
    #如果没有成功创见账户

    it 'can\'t deposit funds' do
      #你就没办法存钱一下就是100没存成功后的结果
      expect { subject.deposit(100) }.to raise_error(RuntimeError, "No account present")
    end
  end
end
