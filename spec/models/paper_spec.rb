require 'rails_helper'

describe Paper, type: :model do
  let(:paper) { create(:paper) }
  let(:name) { Faker::Lorem.unique.word }
  let(:value) { Faker::Lorem.unique.word }

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

  describe 'updating an answer' do
    let(:new_value) { Faker::Lorem.unique.word }

    it 'should copy on write' do
      paper.versions.create
      paper.latest_version.answers.create(name: name, value: value)
      paper.versions.create
      paper.versions.create
      paper.latest_version.answers.first.update(value: new_value)
      expect(paper.latest_version.answers.first.value).to eq(new_value)
      expect(paper.versions[0].answers.first.value).to eq(value)
      expect(paper.versions[1].answers.first.value).to eq(value)
      expect(paper.versions[2].answers.first.value).to eq(new_value)
      expect(paper.versions[0].answers).to eq(paper.versions[1].answers)
    end

    context 'a paper with n versions and m metadata fields, with one updated field per version' do
      let(:version_count) { 5 }
      let(:answer_count) { 5 }

      it 'should have answer_count + version_count - 1 answers rows and answer_count * version_count things_versions rows' do
        paper.versions.create
        answer_count.times do |i|
          paper.latest_version.answers.create(name: i.to_s, value: Faker::Lorem.unique.word)
        end
        expect(Answer.count).to eq(answer_count)
        expect(ThingsVersion.count).to eq(answer_count)
        (version_count - 1).times do
          paper.versions.create
          paper.latest_version.answers.order('RANDOM()').limit(1).first.update(value: Faker::Lorem.word)
        end
        expect(Answer.count).to eq(answer_count + (version_count - 1))
        expect(ThingsVersion.count).to eq(answer_count * version_count)
      end
    end
  end
end
