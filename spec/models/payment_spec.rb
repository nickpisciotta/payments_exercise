require 'rails_helper'

RSpec.describe Payment, type: :model do
  let (:loan) {Loan.create(funded_amount: 5000)}

  it { should belong_to(:loan) }
  it { should validate_numericality_of(:amount) }
  it { should validate_presence_of(:amount) }

  it "writes date attribute to payment" do
    payment = loan.payments.create(amount: 100)
    today = Time.now.strftime("%d %B %Y")

    expect(payment.date).to eq(today)
  end

end
