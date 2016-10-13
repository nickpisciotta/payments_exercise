class Payment < ActiveRecord::Base
  belongs_to :loan

  validates_numericality_of :amount, :greater_than => 0
  validates :amount, presence: true

end
