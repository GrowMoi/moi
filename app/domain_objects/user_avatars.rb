class UserAvatars
  AVATARS = [
    :"1",
    :"2",
    :"3",
    :"4"
  ].freeze

  class << self
    ##
    # @return [Hash] for keys -> img path
    def avatars
      AVATARS.inject({}) do |memo, key|
        memo[key] = "/avatars/avatar-#{key}.png"
        memo
      end
    end
  end
end
