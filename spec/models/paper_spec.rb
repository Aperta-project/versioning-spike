require 'rails_helper'

describe Paper, type: :model do
  let(:paper) { create(:paper) }

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
    paper.latest_version.answers.create(name: 'foo', value: 'bar')
    expect(paper.latest_version.answers.first.name).to eq('foo')
  end
end
