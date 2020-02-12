require 'test_helper'

class NofifierTest < ActionMailer::TestCase
  test "create_account_confirmation" do
    mail = Nofifier.create_account_confirmation
    assert_equal "Create account confirmation", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

end
