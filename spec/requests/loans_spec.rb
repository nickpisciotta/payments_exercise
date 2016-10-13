require 'rails_helper'

RSpec.describe "Retrieve all loans", type: :request do
  let(:loan_one) { Loan.create(funded_amount: 150.0) }
  let(:loan_two) { Loan.create(funded_amount: 200.0) }

  it "returns outstanding balance" do
    loan_one_payment = loan_one.payments.create(amount: 100.0)
    loan_two_payment = loan_two.payments.create(amount: 50.0)
    loan_one_balance = loan_one.funded_amount - loan_one_payment.amount
    loan_two_balance = loan_two.funded_amount - loan_two_payment.amount

    get "/loans"

    expect(response.status).to eq(200)

    expect(json[0]["id"]).to eq(loan_one.id)
    expect(json[0]["funded_amount"]).to eq(loan_one.funded_amount.to_s)
    expect(json[0]["outstanding_balance"]).to eq(loan_one_balance.to_s)
    expect(json[1]["id"]).to eq(loan_two.id)
    expect(json[1]["funded_amount"]).to eq(loan_two.funded_amount.to_s)
    expect(json[1]["outstanding_balance"]).to eq(loan_two_balance.to_s)
  end
end

RSpec.describe "Retrieve a specified loan", type: :request do
  let (:loan) { Loan.create(funded_amount: 100.0) }

  it "returns outstanding balance for a specific loan" do
    loan_payment = loan.payments.create(amount: 50.0)
    loan_balance = loan.funded_amount - loan_payment.amount

    get "/loans/#{loan.id}"

    expect(json["id"]).to eq(loan.id)
    expect(json["funded_amount"]).to eq(loan.funded_amount.to_s)
    expect(json["outstanding_balance"]).to eq(loan_balance.to_s)
  end

end
