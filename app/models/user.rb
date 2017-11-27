# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :inet
#  last_sign_in_ip        :inet
#  created_at             :datetime
#  updated_at             :datetime
#  name                   :string
#  role                   :string           default("cliente"), not null
#  uid                    :string           not null
#  provider               :string           default("email"), not null
#  tokens                 :json
#  birthday               :date
#  city                   :string
#  country                :string
#  tree_image             :string
#  school                 :string
#  username               :string
#  authorization_key      :string
#  age                    :integer
#

class User < ActiveRecord::Base
  include DeviseTokenAuth::Concerns::User
  include Roles
  include ContentReadable
  include ContentLearnable
  include UserContentAnnotable
  include UserContentPreferenceable
  include UserMediaSeen
  include UserStatistics
  include UserContentTasks
  include UserContentFavorites
  include UserReadNotifications

  mount_base64_uploader :tree_image, ContentMediaUploader, file_name: -> { 'tree' }

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :registerable and :omniauthable
  devise :database_authenticatable, :recoverable,
  :rememberable, :trackable

  attr_accessor :login

  after_update :send_role_changed_email

  validates :email, presence: true, uniqueness: true
  validates :username, presence: true,
                       uniqueness: { case_sensitive: false,
                                     allow_blank: true }
  validates_format_of :username, with: /\A[a-zA-Z0-9_\.\-]*\z/, multiline: true
  validates :authorization_key, presence: true, on: :create, if: "cliente?"

  begin :callbacks
    before_validation :skip_password_for_clients
  end

  begin :relationships
    has_one :profile,
            dependent: :destroy
    has_many :content_notes,
             dependent: :destroy
    has_many :learning_tests,
             dependent: :destroy,
             class_name: "ContentLearningTest"
    has_many :content_learnings,
             dependent: :destroy
    has_many :content_reading_times,
             dependent: :destroy
    has_many :learned_contents,
             source: :content,
             through: :content_learnings
    has_many :content_readings,
             dependent: :destroy
    has_many :read_contents,
             source: :content,
             through: :content_readings
    has_many :content_preferences,
             class_name: "UserContentPreference",
             dependent: :destroy
    has_many :content_tasks,
             -> { where deleted: false },
             dependent: :destroy
    has_many :all_tasks,
             source: :content,
             through: :content_tasks
    has_many :tutor_requests_sent,
             foreign_key: :tutor_id,
             class_name: "UserTutor",
             dependent: :destroy
    has_many :tutor_requests_received,
             class_name: "UserTutor",
             dependent: :destroy
    has_many :content_favorites,
             dependent: :destroy
    has_many :all_favorites,
             source: :content,
             through: :content_favorites
    has_many :read_notifications,
             dependent: :destroy
  end

  def to_s
    username
  end

  def confirmed_at
    Time.utc(2000).to_date
  end

  def confirmation_sent_at
    Time.utc(1999).to_date
  end

  private

  def send_role_changed_email
    if role_changed?
    	UserMailer.notify_role_change(self).deliver_later
    end
  end

  def skip_password_for_clients
    if cliente? && password.blank?
      self.password = Devise.friendly_token
      self.password_confirmation = password
    end
  end

  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions.to_hash).where(["lower(username) = :value OR lower(email) = :value", { :value => login.downcase }]).first
    elsif conditions.has_key?(:username) || conditions.has_key?(:email)
      where(conditions.to_hash).first
    end
  end
end
