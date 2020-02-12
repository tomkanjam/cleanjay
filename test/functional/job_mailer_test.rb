require 'test_helper'

class JobMailerTest < ActionMailer::TestCase
  test "user_new_job" do
    mail = JobMailer.user_new_job
    assert_equal "User new job", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

end
