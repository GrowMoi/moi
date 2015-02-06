require "rails_helper"

RSpec.describe User::Roles do
  let(:admin) { create :user, :admin }
  let(:moderador) { create :user, :moderador }
  let(:curador) { create :user, :curador }
  let(:cliente) { create :user, :cliente }

  it { expect(admin).to be_admin }
  it { expect(moderador).to be_moderador }
  it { expect(curador).to be_curador }
  it { expect(cliente).to be_cliente }
end
