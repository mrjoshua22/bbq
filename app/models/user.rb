class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :events

  before_validation :set_name, on: :create

  validates :name, presence: true, length: { maximum: 35 }

  private

  def set_name
    self.name = "Товарищ № #{rand(999)}" if self.name.blank?
  end
end
