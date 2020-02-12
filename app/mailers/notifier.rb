class Notifier < ActionMailer::Base
  default from: "CleanJay Robot <tom@cleanjay.ca>"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.notifier.create_account_confirmation.subject
  #
  def create_cleaner_account_confirmation(account)
		@first_name = account.first_name
		@last_name = account.last_name
		@email = account.email

    mail(:to => "tom@cleanjay.ca", :subject => "New Cleaner Signup!")
  end
end
