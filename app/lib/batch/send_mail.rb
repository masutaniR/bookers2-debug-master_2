class Batch::SendMail
  def self.send_mail
    DailyMailer.daily_mail.deliver_now
  end
end