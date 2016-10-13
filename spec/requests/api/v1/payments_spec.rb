require 'rails_helper'

RSpec.describe "Create payment for a loan", type: :request do
  let(:loan) { Loan.create(funded_amount: 100.00) }

  context "POST api/v1/loan/loan_id/payments with valid data" do
    it "creates new payment for the loan" do

      post "/api/v1/loans/#{loan.id}/payments", payment: { amount: 50.00 }

      expect(response).to have_http_status(:created)

      payment = loan.payments.last

      expect(json['id']).to eq payment.id
      expect(json['amount']).to eq "50.0"
      expect(json['date']).to eq payment.date
    end
  end

  context "payment exceeding the outstanding balance" do
    it "returns error message" do
      post "/api/v1/loans/#{loan.id}/payments", payment: { amount: 150.0 }

      expect(response.status).to eq 400

      expect(json["errors"][0]).to eq("Amount cannot exceed outstanding balance")
    end
  end

  context "invalid payment input data" do
    it "returns validation error messages" do
        post "/api/v1/loans/#{loan.id}/payments", payment: { amount: "Word" }

        expect(response.status).to eq 400

        expect(json["errors"]).to eq(["Amount is not a number"])

        post "/api/v1/loans/#{loan.id}/payments", payment: { amount: ""}

        expect(json["errors"]).to eq(["Amount is not a number",
        "Amount can't be blank"])

        post "/api/v1/loans/#{loan.id}/payments", payment: { amount: 0}

        expect(json["errors"]).to eq(["Amount must be greater than 0"])
    end
  end
end

RSpec.describe "Retrieve all payments for a loan", type: :request do
  let(:loan) { Loan.create(funded_amount: 100.00) }

  context "GET api/v1/loan/loan_id/payments" do
    it "returns all payments" do
      payment_one = loan.payments.create(amount: 25.0)
      payment_two = loan.payments.create(amount: 50.0)
      remaining_loan_balance = loan.funded_amount - payment_one.amount - payment_two.amount

      get "/api/v1/loans/#{loan.id}/payments"

      expect(response).to have_http_status(:ok)
      expect(json[0]["id"]).to eq(payment_one.id)
      expect(json[0]["amount"]).to eq(payment_one.amount.to_s)
      expect(json[0]["date"]).to eq(payment_one.date)
      expect(json[1]["id"]).to eq(payment_two.id)
      expect(json[1]["amount"]).to eq(payment_two.amount.to_s)
      expect(json[1]["date"]).to eq(payment_two.date)
      expect(loan.outstanding_balance).to eq(remaining_loan_balance)
    end
  end

  context "GET api/v1/loan/loan_id/payments/" do
    it "returns a specific payment" do
      payment      = loan.payments.create(amount: 15.0)
      payment_two  = loan.payments.create(amount: 10.0)

      get "/api/v1/loans/#{loan.id}/payments/#{payment.id}"

      expect(response).to have_http_status(:ok)

      expect(json["id"]).to eq(payment.id)
      expect(json["amount"]).to eq(payment.amount.to_s)
      expect(json["date"]).to eq(payment.date)
    end
  end

end
