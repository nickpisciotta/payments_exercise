class Api::V1::PaymentsController < ApiBaseController

  def create
    loan = Loan.find(params[:loan_id])
    payment = loan.payments.new(payment_params)

    if payment.save && loan.payment_less_than_balance?(payment)
      render json: payment, :status => :created
    else
      render json: { errors: payment.errors.full_messages}, :status => :bad_request
    end
  end

  def index
    loan = Loan.find(params[:loan_id])
    payments = loan.payments

    render json: payments
  end

  def show
    loan = Loan.find(params[:loan_id])
    payment = loan.payments.find(params[:id])

    render json: payment
  end

  private
    def payment_params
      params.require(:payment).permit(:amount)
    end
end
