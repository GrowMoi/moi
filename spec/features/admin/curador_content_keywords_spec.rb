require "rails_helper"

describe "curador adds keywords to content" do
  let!(:current_user) { create :user, :curador }

  let(:content_keywords) { content.keywords.map(&:name) }

  let(:keywords) { %w(tag1 tag2) }
  let(:keywords_str) { keywords.join(",") }
  let(:keywords_input) {
    all(
      "input[name$='[keyword_list]']",
      visible: false
    ).first
  }
  let(:description_textarea) {
    find "[name$='[description]']"
  }

  before {
    login_as current_user
  }

  include_context "form features"

  feature "creates new keywords", js: true do
    let!(:neuron) { create :neuron }

    let(:content) { neuron.reload.contents.first }

    before {
      visit edit_admin_neuron_path(neuron)
      select_contents_tab!
      description_textarea.set "Description"
      keywords_input.set keywords_str
      expect {
        submit_form!
      }.to change { ActsAsTaggableOn::Tag.count }.by(2)
    }

    it {
      keywords.each do |keyword|
        expect(content_keywords).to include(keyword)
      end
    }
  end

  feature "adds just one keyword", js: true do
    let!(:neuron) { create :neuron, contents: [content] }

    let(:new_keyword) { "tag5" }
    let(:new_keywords) { keywords + [new_keyword] }
    let(:content) {
      build :content, level: Content::LEVELS.first,
                      kind: Content::KINDS.first,
                      keyword_list: keywords_str
    }

    before {
      expect(ActsAsTaggableOn::Tag.count).to eq(2)
    }

    before {
      visit edit_admin_neuron_path(neuron)
      select_contents_tab!
      description_textarea.set "Description"
      keywords_input.set new_keywords.join(",")
      expect {
        submit_form!
      }.to change { ActsAsTaggableOn::Tag.count }.by(1)
    }

    it {
      new_keywords.each do |keyword|
        expect(content_keywords).to include(keyword)
      end
    }
  end
end
