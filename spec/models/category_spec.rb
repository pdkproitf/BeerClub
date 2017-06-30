require 'rails_helper'

RSpec.describe Category, type: :model do
  subject { FactoryGirl.build :category }

  describe 'validation' do
    context 'is invalid with invalid attributes' do
      subject { FactoryGirl.build :invalid_category }
      it { expect(subject).to be_invalid }
    end

    it 'is valid with valid attributes' do
      expect(subject).to be_valid
    end
  end

  describe 'function' do
    context '#using?' do
      let(:beer) { FactoryGirl.create :beer }
      before do
        subject.save
        beer.update_attributes(category_id: subject.id)
      end
      it 'using' do
        expect(subject.using?).to be true
      end

      it "using" do
        beer.update_attributes(archived: true)
        expect(subject.using?).to be false
      end
    end
  end

  describe 'association' do
    it "has many beer" do
      assc = described_class.reflect_on_association(:beers)
      expect(assc.macro).to eq :has_many
    end
  end
end
