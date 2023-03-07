class EventPolicy < ApplicationPolicy
  def show?
    if record.pincode.present?
      check_pincode(record)
    else
      true
    end
  end

  def new?
    create?
  end

  def create?
    user.present?
  end

  def edit?
    update?
  end

  def destroy?
    update?
  end

  def update?
    user_is_owner?(record)
  end

  class Scope < Scope
  end

  private

  def check_pincode(event)
    if user.present? &&
      ( event.user == user || user.subscriber?(event))
      return true
    end

    if event.pincode_valid?(pincode)
      session["events_#{event.id}_pincode"] = pincode
    end

    unless event.pincode_valid?(session["events_#{event.id}_pincode"])
      return false
    end

    true
  end

  def user_is_owner?(event)
    user.present? && event.user == user
  end
end
