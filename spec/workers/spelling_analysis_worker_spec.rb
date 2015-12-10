require 'rails_helper'

RSpec.describe SpellingAnalysisWorker do
  let(:lang) { "es" }
  let(:description) {
    "texto con herror"
  }
  let!(:content) { create :content }
  let(:description_analysis) {
    content.spellcheck_analyses.for(:description)
  }
  let(:worker) {
    SpellingAnalysisWorker.new(content)
  }
  let(:spellcheck_result) {
    [
      { original: "texto", correct: true },
      { original: "con", correct: true },
      { original: "herror",
        correct: false,
        suggestions: ["herrar", "herir", "error"] }
    ]
  }

  before {
    expect(
      Spellchecker
    ).to receive(:check).with(
      description,
      lang
    ).and_return(
      spellcheck_result
    )
  }

  before {
    content.description = description
    content.spellcheck_analyses.for(:description).destroy # mimic schedule

    expect {
      worker.run!
    }.to change {
      SpellcheckAnalysis.count
    }.by(1)
  }

  it {
    expect(
      description_analysis.words.length
    ).to eq(1)
  }

  it {
    expect(
      description_analysis.words.first["original"]
    ).to eq("herror")
  }

  it {
    expect(
      description_analysis.words.first["suggestions"]
    ).to include("error")
  }

  it {
    expect(
      description_analysis.words.first
    ).to_not have_key("correct")
  }
end
