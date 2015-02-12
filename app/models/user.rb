class User < ActiveRecord::Base
  include Roles

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :registerable and :omniauthable
  devise :database_authenticatable, :recoverable,
  :rememberable, :trackable, :validatable

  after_update :send_email_change_role

  def to_s
    name
  end

  private

  def send_email_change_role
    if self.role_changed? #get boolean value before to save object
    	UserMailer.notify_role_change(self).deliver_later
    end
  end
end
