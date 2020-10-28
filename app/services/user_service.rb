
class UserService
  def initialize(users)
    @users = users
  end

  def run!
    users_created = []
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
      if user.save!
        users_created << user.id
      end
    end
    users_created
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
