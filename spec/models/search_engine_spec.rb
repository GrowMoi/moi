require 'rails_helper'

RSpec.describe SearchEngine, :type => :model do
  describe "factory" do
    let(:search_engine) { build :search_engine }
    it {
      expect(search_engine).to be_valid
    }
  end
end
