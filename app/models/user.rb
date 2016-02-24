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
#

class User < ActiveRecord::Base
  include DeviseTokenAuth::Concerns::User
  include Roles
  include ContentLearnable

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :registerable and :omniauthable
  devise :database_authenticatable, :recoverable,
  :rememberable, :trackable, :validatable

  after_update :send_role_changed_email

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true

  begin :relationships
    has_one :profile,
            dependent: :destroy
    has_many :content_learnings
    has_many :learned_contents,
             source: :content,
             through: :content_learnings
  end

  def to_s
    name
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
end
