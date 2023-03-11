class EventMailer < ApplicationMailer

  def subscription(event, subscription)
    @email = subscription.user_email
    @name = subscription.user_name
    @event = event

    mail to: event.user.email,
      subject: default_i18n_subject(event: @event.title)
  end

  def comment(comment, email)
    @comment = comment

    mail to: email,
      subject: default_i18n_subject(event: @comment.event.title)
  end

  def photo(photo, email)
    @photo = photo
    @event = @photo.event

    mail to: email,
      subject: I18n.t('event_mailer.photo.subject', event: @event.title)
  end
end
