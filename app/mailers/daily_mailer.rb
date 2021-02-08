class DailyMailer < ApplicationMailer
  def daily_mail
    mail(subject: '確認メール', bcc: User.pluck(:email))
  end
end
