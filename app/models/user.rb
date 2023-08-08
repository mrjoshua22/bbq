class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: %i[github vkontakte]

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

  def self.from_omniauth(access_token)
    data = access_token.info
    user =
      if data['email'].present?
        User.where(email: data['email']&.downcase).first
      else
        User.where(url: data['urls'].values.first).first
      end

    unless user
        user = User.create(
          name: data['name'],
          email: data['email'],
          password: Devise.friendly_token[0,20],
          url: data['urls'].values.first,
          provider: access_token.provider
        )
    end

    user
  end

  def email_required?
    super && provider.blank?
  end

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
