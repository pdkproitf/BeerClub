require 'rails_helper'

RSpec.describe Conversation, type: :model do

  let(:sender) { FactoryGirl.create(:user, email: Faker::Internet.email,role: Role.find_or_create_by(name: 'Admin')) }
  let(:recipient) { FactoryGirl.create(:user, email: Faker::Internet.email, role: Role.find_or_create_by(name: 'Admin')) }

  describe 'validation' do
    context 'with invalid attributes' do
      it 'uniqueness' do
        subject { FactoryGirl.build(:conversation, sender: nil, recipient: recipient) }
        expect(subject).to be_invalid
      end

      it 'chat them self' do
        subject { FactoryGirl.build(:conversation, sender: recipient, recipient: recipient) }
        expect(subject).to be_invalid
      end
    end

    it 'with valid attributes' do
      conversation = FactoryGirl.create(:conversation, sender: sender, recipient: recipient)
      expect(conversation).to be_valid
    end
  end

  describe 'function' do
    context '#self.get' do
      it "get exist conversation" do
        conversation = FactoryGirl.create(:conversation, sender: sender, recipient: recipient)
        expect(Conversation.get(sender, recipient)).to eq(conversation)
      end

      it "create new conversation" do
        expect(Conversation.exists?(sender_id: sender, recipient_id: recipient)).to be false
        conversation = Conversation.get(sender.id, recipient.id)
        expect(Conversation.exists?(sender_id: sender, recipient_id: recipient)).to be true
      end
    end

    it '#opposed_user' do
      conversation = FactoryGirl.create(:conversation, sender: sender, recipient: recipient)
      expect(conversation.opposed_user(sender)).to eq(recipient)
    end
  end

  describe 'association' do
    it "belongs to sender" do
        assc = described_class.reflect_on_association(:sender)
        expect(assc.macro).to eq :belongs_to
    end

    it "belongs to sender" do
        assc = described_class.reflect_on_association(:recipient)
        expect(assc.macro).to eq :belongs_to
    end

    it "have messages " do
        assc = described_class.reflect_on_association(:messages)
        expect(assc.macro).to eq :has_many
    end
  end
end
