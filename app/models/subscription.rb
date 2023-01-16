class Subscription < ApplicationRecord
  belongs_to :event
  belongs_to :user, optional: true

  validates :user_name, presence: true, unless: -> { user.present? }
  validates :user_email, presence: true,
    format: /\A[a-zA-Z0-9\-_.]+@[a-zA-Z0-9\-_.]+\z/,
    unless: -> { user.present? }

  validates :user, uniqueness: { scope: :event_id }, if: -> { user.present? }
  validates :user_email, uniqueness: { scope: :event_id },
    unless: -> { user.present? }

  validate :forbid_event_creator_to_subscribe, on: :create
  validate :forbid_to_use_registered_email, on: :create

  def user_name
    if user.present?
      user.name
    else
      super
    end
  end

  def user_email
    if user.present?
      user.email
    else
      super
    end
  end

  private

  def forbid_to_use_registered_email
    if User.find_by(email: self.user_email).present?
      errors.add(
        :user_email,
        I18n.t('activerecord.errors.registered_user_email')
      )
    end
  end

  def forbid_event_creator_to_subscribe
    if event.user == user
      errors.add(
        :user_id,
        I18n.t('activerecord.errors.forbid_subscription')
      )
    end
  end
end
