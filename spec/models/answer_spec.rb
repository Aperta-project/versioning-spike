require 'rails_helper'

RSpec.describe Answer, type: :model do
  let!(:paper) { FactoryGirl.create(:paper) }
  let!(:version_a) { FactoryGirl.create(:version, paper: paper, number: 1) }

  describe '#shared' do
    it 'is true if this answer is shared across 2 versions' do
      paper.versions.create
      paper.latest_version.answers.create(name: Faker::Lorem.word, value: Faker::Lorem.word)
      paper.versions.create
      expect(paper.latest_version.answers.first.shared?).to be(true)
    end
  end
end
