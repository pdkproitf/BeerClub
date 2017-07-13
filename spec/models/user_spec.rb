require 'rails_helper'

RSpec.describe User, type: :model do

  subject { FactoryGirl.build(:user, role: Role.find_or_create_by(name: 'Admin')) }

  describe 'validation' do
    context 'is invalid with invalid attributes' do
      subject { FactoryGirl.build :invalid_user }
      it { expect(subject).to be_invalid }
    end

    it 'is valid with valid attributes' do
      expect(subject).to be_valid
    end
  end

  describe 'function' do
    before do
      subject.email = subject.email.upcase
      subject.save
    end

    it '.downcase_email' do
      expect(subject.email).to eq subject.email.downcase
    end

    it '#admin?' do
      expect(subject.admin?).to be true
    end
  end

  describe 'association' do
    it "belongs to role" do
        assc = described_class.reflect_on_association(:role)
        expect(assc.macro).to eq :belongs_to
    end
  end
end
