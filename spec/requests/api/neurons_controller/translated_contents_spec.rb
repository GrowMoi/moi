require "rails_helper"

RSpec.describe Api::TreesController,
               type: :request do
  include RootNeuronMockable

  describe "contents are translated depending on user preferences" do
    let(:root) { create :neuron_visible_for_api }
    let(:target_content) { root.contents.first }
    let(:translate_title) do
      create :translated_attribute,
             translatable: target_content,
             name: :title,
             content: "translated_title",
             language: "en"
    end
    let(:translate_description) do
      create :translated_attribute,
             translatable: target_content,
             name: :description,
             content: "translated_description",
             language: "en"
    end
    let(:translate_source) do
      create :translated_attribute,
             translatable: target_content,
             name: :source,
             content: "translated_source",
             language: "en"
    end

    include_examples "requests:current_user"

    before do
      translate_title
      translate_description
      translate_source
      root_neuron root
      # mock user preference
      allow_any_instance_of(User).to receive(:preferred_lang).and_return("en")
    end

    it {
      get "/api/neurons/#{root.id}/contents/#{target_content.id}"
      subject = JSON.parse(response.body)
      expect(subject["title"]).to eq(translate_title.content)
      expect(subject["description"]).to eq(translate_description.content)
      expect(subject["source"]).to eq(translate_source.content)
    }
  end
end
