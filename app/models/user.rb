class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :events
  has_many :comments, dependent: :destroy
  has_many :subscriptions
  has_many :photos

  has_one_attached :avatar do |attachable|
    attachable.variant :thumb, resize_to_fill: [100, 100]
    attachable.variant :default, resize_to_fill: [400, 400]
  end

  before_validation :set_name, on: :create

  after_commit :link_subscriptions, on: :create

  validates :name, presence: true, length: { maximum: 35 }

  validates :avatar,
    content_type: %w[image/jpeg image/png image/gif],
    size: { less_than: 5.megabytes }

  def subscriber?(event)
    event.subscribers.find_by(email: email).present?
  end

  private

  def link_subscriptions
    Subscription.where(user_id: nil, user_email: self.email).update_all(user_id: self.id)
  end

  def set_name
    self.name = "Товарищ № #{rand(999)}" if self.name.blank?
  end
end
