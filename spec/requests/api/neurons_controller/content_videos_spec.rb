require "rails_helper"

RSpec.describe Api::NeuronsController,
               type: :request do
  include_examples "requests:current_user"
  include_examples "neurons_controller:approved_content"

  subject {
    JSON.parse(response.body).fetch("neuron")
  }

  describe "includes videos in content" do
    let!(:content_video) {
      create :content_video,
             content: content
    }

    describe "url" do
      before { get "/api/neurons/#{neuron.id}" }

      it {
        expect(
          subject["contents"].first["videos"].first["url"]
        ).to eq(content_video.url)
      }
    end

    describe "thumbnail" do
      let(:response_thumbnail) {
        subject["contents"].first["videos"].first["thumbnail"]
      }

      describe "supported party" do
        let(:video_id) { "VIDEOID" }

        let!(:content_video) {
          create :content_video,
                 content: content,
                 url: "http://youtube.com/?v=#{video_id}"
        }

        let(:thumbnail_url) {
          "//img.youtube.com/vi/#{video_id}/0.jpg"
        }

        before { get "/api/neurons/#{neuron.id}" }

        it {
          expect(response_thumbnail).to eq(thumbnail_url)
        }
        it {
          expect(response_thumbnail).to include(video_id)
        }
      end

      describe "unsupported party" do
        let!(:content_video) {
          create :content_video,
                 content: content,
                 url: "http://provider.com/?v=id"
        }

        before { get "/api/neurons/#{neuron.id}" }

        it {
          expect(response_thumbnail).to be_nil
        }
      end
    end
  end
end
