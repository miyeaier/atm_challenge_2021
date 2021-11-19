require "./lib/account.rb"
describe Account do
  subject { Account.new }

  let(:person) {
    instance_double("Person", name: "Miyesier")
  }
  subject { described_class.new({ owner: person }) }

  it "check the lenght of number" do
    number = 1234
    number_lenght = Math.log10(number).to_i + 1
    expect(number_lenght).to eq 4
  end

  it "is expected to have an expiry date on initialize" do
    #here we set the validity of the card to 5 yrs as default
    expected_date = Date.today.next_year(5).strftime("%m/%y")
    expect(subject.exp_date).to eq expected_date
  end

  it "is expected to have :active status on initialize" do
    expect(subject.account_status).to eq :active
  end

  it "is expected deactivates account using the class method" do
    Account.deactivate(subject)
    expect(subject.account_status).to eq :deactivated
  end

  it "is expected to have an owner" do
    expect(subject.owner).to eq person
  end

  it "is expected to raise error is no owner is set" do
    expect { described_class.new }.to raise_error "An Account owner is required"
  end
end
