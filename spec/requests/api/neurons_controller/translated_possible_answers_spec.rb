require "rails_helper"

RSpec.describe Api::TreesController,
               type: :request do
  include RootNeuronMockable

  describe "possible answers are translated depending on user preferences" do
    include_examples "requests:current_user"

    let(:root) { create :neuron_visible_for_api }
    # let(:target_content) { root.contents.first }
    let(:target_content) do
      create :content,
             :approved,
             :with_possible_answers,
             neuron: root
    end
    let(:previous_readings_count) do
      TreeService::ReadingTestFetcher::MIN_COUNT_FOR_TEST - 1
    end
    let(:already_viewed_contents) do
      previous_readings_count.times.map do
        create :content,
               :approved,
               :with_possible_answers,
               neuron: root
      end
    end
    let(:previous_readings) do
      already_viewed_contents.map do |content|
        create :content_reading,
               content: content,
               user: current_user
      end
    end
    let(:translate_possible_answers) do
      already_viewed_contents.map do |content|
        content.possible_answers.map do |possible_answer|
          create :translated_attribute,
                 translatable: possible_answer,
                 name: :text,
                 content: "translated_possible_answer_#{possible_answer.id}",
                 language: "en"
        end
      end.flatten
    end

    before do
      root_neuron root
      previous_readings
      translate_possible_answers
      # mock user preference
      allow_any_instance_of(User).to receive(:preferred_lang).and_return("en")
    end

    it {
      post "/api/neurons/#{root.id}/contents/#{target_content.id}/read"
      json = JSON.parse(response.body)
      translate_possible_answers.each do |translation|
        expect(
          json["test"]["questions"].any? do |question|
            question["possible_answers"].any? do |possible_answer|
              possible_answer["text"] == translation.content
            end
          end
        ).to be_truthy
      end
    }
  end
end
