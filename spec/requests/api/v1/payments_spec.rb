require 'rails_helper'

RSpec.describe "Create payment for a loan", type: :request do
  let(:loan) { Loan.create(funded_amount: 100.00) }

  context "POST api/v1/loan/loan_id/payments with valid data" do
    it "creates new payment for the loan" do

      post "/api/v1/loan/#{loan.id}/payments", payment: { amount: 50.00 }

      expect(response).to have_http_status(:created)

      parsed_response = JSON.parse(response.body)
      payment = loan.payments.last

      expect(parsed_response['id']).to eq payment.id
      expect(parsed_response['amount']).to eq "50.0"
      byebug
      expect(parsed_response['date']).to eq payment.date
    end
  end
end
