namespace :users do
  desc "rake users:create[sean.iams@gmail.com,asdf]"
  task :create, [:email_address, :password] => [:environment] do |t, args|
    user = User.new(:email_address => args[:email_address])
    user.password = args[:password]
    user.password_confirmation = args[:password]
    user.save
  end
end

namespace :notes do
  desc "rake notes:assign_to_user[sean.iams@gmail.com]"
  task :assign_to_user, [:email_address] => [:environment] do |t, args|
    user = User.find_by_email_address(args[:email_address])
    Note.all.each do |note|
      note.user_id = user.id
      note.save!
    end
  end
end