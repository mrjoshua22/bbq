# frozen_string_literal: true

class ApplicationPolicy
  attr_reader :user, :pincode, :record
  attr_accessor :session

  def initialize(user_context, record)
    @user = user_context.user
    @session = user_context.session
    @pincode = user_context.pincode
    @record = record
  end

  def index?
    false
  end

  def show?
    false
  end

  def create?
    false
  end

  def new?
    create?
  end

  def update?
    false
  end

  def edit?
    update?
  end

  def destroy?
    false
  end

  class Scope
    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      raise NotImplementedError, "You must define #resolve in #{self.class}"
    end

    private

    attr_reader :user, :scope
  end
end
