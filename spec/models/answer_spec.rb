require 'rails_helper'

RSpec.describe Answer, type: :model do
  let!(:paper) { FactoryGirl.create(:paper) }
  let!(:version_a) { FactoryGirl.create(:version, paper: paper, number: 1) }

  it '' do
    version_a.answers.create(name: 'title', value: 'a nice paper')
  end
end
