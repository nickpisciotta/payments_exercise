class Payment < ActiveRecord::Base
  belongs_to :loan

  validates_numericality_of :amount, :greater_than => 0
  validates :amount, presence: true

  before_save :payment_date

  def payment_date
    write_attribute :date, Time.now.strftime("%d %B %Y")
  end

end
