class UserContext
  attr_reader :user, :session, :pincode

  def initialize(user, session, pincode)
    @user = user
    @session = session
    @pincode = pincode
  end
end
