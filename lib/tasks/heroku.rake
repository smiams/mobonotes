namespace :users do
  desc "rake users:create [sean.iams@gmail.com,asdf]"
  task :create, [:email_address, :password] => [:environment] do |t, args|
    user = User.new(:email_address => args[:email_address])
    user.password = args[:password]
    user.password_confirmation = args[:password]
    user.save
  end
end