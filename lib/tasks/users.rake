namespace :users do
  desc "Promote an existing user to admin using their email"
  task :make_admin, [:email] => :environment do |_task, args|
    email = args[:email]

    if email.blank?
      puts "Error: Please provide an email address."
      exit 1
    end

    user = User.find_by(email: email)

    if user
      user.update!(role: "admin")
      puts "#{user.email} has been promoted to admin."
    else
      puts "Error: No user found with email #{email}."
      exit 1
    end
  end
end
