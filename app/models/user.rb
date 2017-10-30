class User < ApplicationRecord
  has_many :transfers
  validates :first_name, presence: true, length: {maximum: 20}
  validates :last_name, presence: true, length: {maximum: 20}
  validates :address_line_1, presence: true, length: {maximum: 50}
  validates :DOB, presence: true

  def age
    # This trick actually works because notion of "age" is lexicographic
    # not based on how much time actually elapsed.
    # The only difference compared with naive methods is with leap years
    # It feels like this should go into ActiveSupport
    (Date.today.to_s(:number).to_i - self.DOB.to_s(:number).to_i) / 10000
  end

  def name
    "#{first_name} #{last_name}"
  end
end
