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

end
