require 'rails_helper'

describe Paper, type: :model do
  let(:paper) { create(:paper) }
  let(:name) { Faker::Lorem.word }
  let(:value) { Faker::Lorem.word }

  it 'should create a new version with increasing numbers' do
    paper.versions.create
    expect { paper.versions.create }.to change { paper.versions.maximum(:number) }.from(0).to(1)
  end

  it 'should update the latest_version belongs_to' do
    paper.versions.create
    expect { paper.versions.create }.to change { paper.latest_version.number }.from(0).to(1)
  end

  it 'should have answers' do
    paper.versions.create
    paper.latest_version.answers.create(name: name, value: value)
    expect(paper.latest_version.answers.first.name).to eq(name)
  end

  it 'should copy answer when creating a new version' do
    paper.versions.create
    paper.latest_version.answers.create(name: name, value: value)
    paper.versions.create
    expect(paper.latest_version).to_not eq(paper.versions.first)
    expect(paper.latest_version.answers.first.name).to eq(name)
  end

  it 'should copy 1000 answers when creating a new version' do
    paper.versions.create
    1000.times do
      paper.latest_version.answers.create(name: Faker::Lorem.word, value: Faker::Lorem.word)
    end
    paper.versions.create
    expect(paper.latest_version).to_not eq(paper.versions.first)
    expect(paper.latest_version.answers).to eq(paper.versions.first.answers)
  end
end
