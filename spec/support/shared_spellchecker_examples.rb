RSpec.shared_examples "spellchecker examples" do
  describe "schedules spelling analysis" do
    before {
      expect(
        SpellingAnalysisWorker
      ).to receive(:perform!).with(resource.id).and_call_original
    }

    it {
      resource.update_attribute tracked_attribute,
                                "new description"
    }
  end

  describe "does not schedule spelling analysis if nothing analised changed" do
    before {
      expect(
        SpellingAnalysisWorker
      ).not_to receive(:perform!)
    }

    it {
      resource.update_attribute untracked_attribute,
                                "new description"
    }
  end
end
