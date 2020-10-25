
require 'csv'
class UserService
  def initialize(users)
    @users = users
  end

  def run!
    out_uri = "generate_users_task-#{Time.now.to_s.parameterize}.csv"
    @csv_out = CSV.open(Rails.root.join("public", out_uri), "wb")
    @csv_out << ["username", "authorization_key", "name", "email", "authorization_key_es"]
    @users.each do |user_names|
      user = User.new(
        name: user_names,
        authorization_key: UserAuthorizationKeys::KEYS.sample
      )
      count = 0
      username = generate_username(user_names, count)
      email = "#{username}@growmoi.com"
      while User.exists?(username: username) || User.exists?(email: email)
        count += 1
        username = generate_username(user_names, count)
        email = "#{username}@growmoi.com"
      end
      user.email = email
      user.username = username
      user.save!
      key_pass = user.authorization_key
      key_pass_es = UserAuthorizationKeys::KEYS_ES[key_pass.to_sym]
      @csv_out << [user.username, key_pass, user.name, user.email, key_pass_es]
      puts [user.username, key_pass, user.name, user.email, key_pass_es]
    end
    puts "done! open at #{out_uri}"
  end

  private

  def generate_username(user_names, count)
    user_names = user_names.mb_chars.normalize(:kd).gsub(/[^\x00-\x7F]/n,'').downcase.to_s
    split_names = user_names.split(" ")
    last_name = split_names[0]
    first_name = split_names[2]
    "#{last_name}#{first_name}#{(count == 0 ? "" : count)}".parameterize
  end
end
