require "./lib/atm.rb"

describe Atm do
  subject { Atm.new }
  it 'is expected to have $1000 when instantiated' do
    expect(subject.funds).to eq 1000
  end

  it 'is expected to reduce funds on withdraw' do
    subject.withdraw 50
    expect(subject.funds).to eq 950
  end
end