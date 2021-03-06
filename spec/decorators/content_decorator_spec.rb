require "rails_helper"

describe ContentDecorator do
  let(:content) { create :content }
  let(:decorator) { described_class.new(content) }

  describe "#source_is_uri?" do
    describe "uris:" do
      sources = [
        "http://google.com",
        "https://facebook.com/",
        "http://127.0.0.1/",
        "http://google.com",
        "http://macool.me/something/else.txt"
      ].each do |source|
        it "'#{source}' should be uri" do
          content.source = source
          expect(
            decorator.send(:source_is_uri?)
          ).to be_truthy
        end
      end
    end

    describe "non-uris:" do
      sources = [
        "author",
        "something else",
        "http://www.addictinggames.com/action-games/little-life-game.jsp http://www.miniclip.com/games/once-upon-a-life/en/" # failing example. only one uri
      ].each do |source|
        it "'#{source}' should not be uri" do
          content.source = source
          expect(->{
            decorator.send(:source_is_uri?)
          }.call).to be_falsey
        end
      end
    end
  end

  describe "#can_have_more_links?" do
    subject { decorator }
    it {
      is_expected.to be_able_to_have_more_links
    }

    context "can't" do
      let!(:links) {
        1.upto(Content::NUMBER_OF_LINKS).each do
          create :content_link,
                 content: subject,
                 language: ApplicationController::DEFAULT_LANGUAGE
        end
      }

      it {
        is_expected.to_not be_able_to_have_more_links
      }
    end
  end
end
