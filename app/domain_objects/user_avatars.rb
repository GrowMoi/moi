class UserAvatars
  AVATARS = [
    :"1",
    :"2",
    :"3",
    :"4",
    :"5",
    :"6",
    :"7",
    :"8"
  ].freeze

  class << self
    ##
    # @return [Hash] for keys -> img path
    def avatars
      AVATARS.inject({}) do |memo, key|
        memo[key] = "/avatar-#{key}.png"
        memo
      end
    end
  end
end
