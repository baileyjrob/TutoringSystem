require 'rails_helper'

RSpec.describe EncryptionService, type: :model do
    describe '#call' do
        let(:sender) { create(:user) }
        let!(:sender_account) { create(:account, balance: 1_000, user: sender) }

        let(:receiver) { create(:user) }
        let!(:receiver_account) { create(:account, balance: 0, user: receiver) }
    end
end