class Api::V1::PaymentsController < ApiBaseController

  def create
    loan = Loan.find(params[:loan_id])
    payment = loan.payments.new(payment_params)

    if payment.save
      render json: payment, :status => :created
    else
      render json: { errors: payment.errors.full_messages}, :status => :bad_request
    end 
  end


  private
    def payment_params
      params.require(:payment).permit(:amount)
    end
end
