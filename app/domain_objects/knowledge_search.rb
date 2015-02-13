require 'google/api_client'

class KnowledgeSearch
  attr_accessor :query, :lang, :source

  ##
  # @param options [Object]
  # @option options [String] :query Required.
  # @option options [String] :lang ("es")
  # @option options [String] :source ("wikipedia")
  def initialize(options={})
    defaults = {
      lang: "es",
      source: "wikipedia"
    }
    defaults.merge(options).each do |key, value|
      send "#{key}=", value
    end
  end

  ##
  # @return [Google::APIClient::Schema::Customsearch::V1::Search]
  #   Search results
  def search
    google_client.execute(
      search_api.cse.list,
      q: query,
      cx: search_engine.gcse_id,
      lr: "lang_#{lang}" # "lang_es" | "lang_en"
    ).data # .items
  end

  private

  def search_engine
    @search_engine ||=
      SearchEngine.active.find_by!(slug: source)
  end

  def search_api
    @search_api ||=
      google_client.discovered_api("customsearch")
  end

  def google_client
    @google_client ||= Google::APIClient.new(
      key: Rails.application.secrets.google_api_key,
      authorization: nil
    )
  end
end
