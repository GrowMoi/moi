require "rails_helper"

RSpec.describe Admin::NeuronsController,
               type: :controller do
  describe "#formatted_contents" do
    let!(:current_user) {
      create :user, :admin
    }

    before {
      sign_in current_user
      get :new
    }

    describe "format" do
      # {
      #   level1 =>
      #     {
      #       kind1 => [ content1, content2, ... ],
      #       kind2 => [ content3, content4, ... ]
      #     },
      #   ...
      # }
      #
      Content::LEVELS.each do |level|
        it "level #{level}" do
          expect(
            controller.formatted_contents
          ).to have_key(level)
        end

        Content::KINDS.each do |kind|
          it "level #{level} - kind #{kind}" do
            expect(
              controller.formatted_contents[level]
            ).to have_key(kind)
          end
        end
      end
    end
  end
end
