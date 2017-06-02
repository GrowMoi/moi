require 'csv'

class GenerateRandomUsersTask
  class << self
    def generate_random_clients!(count)
      new(role: :cliente, count: count).run!
    end

    def generate_random_tutors!(count)
      new(role: :tutor, count: count).run!
    end
  end

  def initialize(role:, count:)
    @role = role
    @count = count.to_i
    set_min_ids!
  end

  def run!
    filename = get_csv_filename
    CSV.open(Rails.root.join("public", filename), "w") do |csv|
      csv << ["email", "password"]

      @created = 0
      while @created < @count
        user = build_user
        if user.save
          @created += 1
          csv << [user.email, user.password]
        end
      end
    end
    puts "generated #{@created} #{@role.to_s.pluralize}"
    puts "download @ #{Rails.application.secrets.url}/#{filename}"
  end

  private

  def set_min_ids!
    @emailids = 0
    if User.count > 0
      @min_user_id = User.order(id: :desc).first.id
    else
      @min_user_id = 1
    end
  end

  def get_csv_filename
    now = Time.now.to_s.gsub(/\ /, '_').gsub(/:/, '_')
    "#{self.class.name.underscore}_#{@role}_#{now}.csv"
  end

  def build_user
    password = random_password
    User.new(
      name: "Usuario Moi",
      email: random_email,
      password: password,
      password_confirmation: password,
      role: @role
    )
  end

  def random_password
    SecureRandom.urlsafe_base64(6)
  end

  def random_email
    @emailids += 1
    uniqueid = @min_user_id + @created + @emailids
    "#{@role}#{uniqueid}@growmoi.com"
  end
end
