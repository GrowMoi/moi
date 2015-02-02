class User < ActiveRecord::Base
  module Roles
    extend ActiveSupport::Concern

    ROLES = %w(admin moderador curador cliente)

    included do
      validates :role, presence: true,
                       inclusion: {in: ROLES}
    end

    # allows calling of `#admin?` `#moderador?`
    ROLES.each do |role|
      define_method "#{role}?" do
        role == role
      end
    end
  end
end
