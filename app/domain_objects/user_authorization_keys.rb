class UserAuthorizationKeys
  KEYS = [
    :animals,
    :places,
    :sports,
    :comunication,
    :stories,
    :art,
    :emotions,
    :space,
    :numbers,
    :plants
  ].freeze

  class << self
    ##
    # @return [Hash] for keys -> img path
    def interests
      KEYS.inject({}) do |memo, key|
        memo[key] = "/authorization_keys/#{key}-interest.png"
        memo
      end
    end
  end
end
