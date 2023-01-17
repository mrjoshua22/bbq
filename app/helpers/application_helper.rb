module ApplicationHelper
  def user_avatar(user)
    if user.avatar.attached?
      user.avatar.variant(:default)
    else
      asset_path('user.png')
    end
  end
end
