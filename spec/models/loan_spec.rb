require 'rails_helper'

RSpec.describe Loan, type: :model do
  let(:loan) {Loan.create(funded_amount: 5000)}

  it { should have_many(:payments) }

  it "calculates remaining balance" do
    loan.payments.create(amount: 3000)

    expect(loan.outstanding_balance).to eq(2000)
  end

end
