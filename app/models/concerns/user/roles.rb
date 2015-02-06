class User < ActiveRecord::Base
  module Roles
    extend ActiveSupport::Concern

    # roles that will be used by the users
    ROLES = %w(admin moderador curador cliente)

    included do
      validates :role, presence: true,
                       inclusion: {in: ROLES}
    end

    # Define method names based on existing roles.
    # Allows calling of `#admin?` `#moderador?`
    #
    # @!method role?
    # @return [Boolean]
    ROLES.each do |role|
      define_method "#{role}?" do
        role == role
      end
    end
  end
end
