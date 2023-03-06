class UserContext
  attr_reader :user, :pincode
  attr_accessor :session

  def initialize(user, session, pincode)
    @user = user
    @session = session
    @pincode = pincode
  end
end
