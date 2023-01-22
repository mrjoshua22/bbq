class EventMailer < ApplicationMailer

  def subscription(event, subscription)
    @email = subscription.user_email
    @name = subscription.user_name
    @event = event

    mail to: event.user.email,
      subject: I18n.t('event_mailer.subscription.subject', event: @event.title)
  end

  def comment(comment, email)
    @comment = comment

    mail to: email,
      subject: I18n.t('event_mailer.comment.subject', event: @comment.event.title)
  end
end
