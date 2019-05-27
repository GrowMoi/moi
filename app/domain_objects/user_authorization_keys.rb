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

  KEYS_ES = {
    animals: "animal",
    places:"globo",
    sports:"pelota",
    comunication:"mensaje",
    stories:"libro",
    art:"arte",
    emotions:"mascara",
    space:"planeta",
    numbers:"numero",
    plants:"planta",
  }

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
