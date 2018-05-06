require 'test_helper'

class MentorConfirmationMailerTest < ActionMailer::TestCase
  test "assigned without personalized message" do
    mail = MentorConfirmationMailer.assigned(doctors(:bob), '')
    assert_equal 'Your Student, Bob, Has Been Assigned To A Patient', mail.subject
    assert_equal ["lulu.sheng1418@gmail.com"], mail.to
    assert_equal "Lulu Sheng lulu.sheng1418@gmail.com", mail.from
    assert_match /This email has been sent to you in order to inform you that your student/, mail.body.encoded
  end

  test "assigned with personalized message" do
    mail = MentorConfirmationMailer.assigned(doctors(:bob), 'testing TesTING testing JellyFISH')
    assert_equal 'Your Student, Bob, Has Been Assigned To A Patient', mail.subject
    assert_equal ["lulu.sheng1418@gmail.com"], mail.to
    assert_equal "Lulu Sheng lulu.sheng1418@gmail.com", mail.from
    assert_match /testing TesTING testing JellyFISH/, mail.body.encoded
  end
  end
