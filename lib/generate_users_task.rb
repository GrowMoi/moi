require 'csv'
class GenerateUsersTask
  def initialize(id_import)
    @id_import = id_import
  end

  def run!
    import = UserImporting.find(@id_import)
    users_created = []
    split_users = import.list.split("\r\n").map {|name| name.strip}
    split_users = split_users.reject(&:empty?)
    out_uri = "generate_users_task-#{Time.now.to_s.parameterize}.csv"
    @csv_out = CSV.open(Rails.root.join("public", out_uri), "wb")
    @csv_out << ["username", "authorization_key", "name", "email", "authorization_key_es", "status"]
    split_users.each do |user_names|
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
      begin
        user.save!
      rescue Exception => e
        @csv_out << ["", "", user.name, "", "", "failed"]
      else
        users_created << user.id
        key_pass = user.authorization_key
        key_pass_es = UserAuthorizationKeys::KEYS_ES[key_pass.to_sym]
        @csv_out << [user.username, key_pass, user.name, user.email, key_pass_es, "created"]
        puts [user.username, key_pass, user.name, user.email, key_pass_es]
      end
    end
    import.file_name = out_uri;
    import.users = users_created;
    import.save
  end

  private

  def generate_username(user_names, count)
    user_names = user_names.mb_chars.normalize(:kd).gsub(/[^\x00-\x7F]/n,'').downcase.to_s
    split_names = user_names.split(" ")
    if split_names.count == 2
      last_name = split_names[0]
      first_name = split_names[1]
    else
      last_name = split_names[0] || ""
      first_name = split_names[2] || ""
    end
    "#{last_name}#{first_name}#{(count == 0 ? "" : count)}".parameterize
  end
end
