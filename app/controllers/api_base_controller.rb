class ApiBaseController < ApplicationController
  protect_from_forgery with: :null_session

  def create
    loan = Loan.find(params[:loan_id])
    payment = loan.payments.new(payment_params)
  end


end
