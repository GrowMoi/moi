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
#

module Api
  class UserSearchSerializer < ActiveModel::Serializer
    root false

    attributes :id,
               :email,
               :name,
               :username,
               :country,
               :school,
               :city,
               :content_summary,
               :image,
               :avatar

    def content_summary
      {
        current_learnt_contents: object.content_learnings.count,
        total_approved_contents: Neuron.approved_public_contents.count
      }
    end

    def image
      object.image ? object.image.url : ''
    end
  end
end
