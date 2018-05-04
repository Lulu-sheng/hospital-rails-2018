class MentorConfirmationMailer < ApplicationMailer
  default from: 'Lulu Sheng lulu.sheng1418@gmail.com'

  def assigned(id)
    mail to: ""
  end
end
