class ThanksMailer < ApplicationMailer
  def thanks_mail(user)
    @user = user
    mail(subject: '登録完了のお知らせ', to: @user.email)
  end
end
