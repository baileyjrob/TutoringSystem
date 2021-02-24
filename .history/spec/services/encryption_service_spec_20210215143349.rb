require 'rails_helper'

RSpec.describe EncryptionService, type: :model do
    #describe 'Encryption and Decryption' do
        #let(:sender) { create(:user) }
        #let!(:sender_account) { create(:account, balance: 1_000, user: sender) }
        #let(:encrypted_data) {EncryptionService.encrypt(data)}

        context 'using random data' do
            data = 'random'
            encrypted_data = EncryptionService.encrypt(data)
            decrypted_data = EncryptionService.decrypt(encrypted_data)
            it 'encrypts data' do
                expect(encrypted_data).not_to eq(data)
            end
            it 'decrypts data' do
                expect(decrypted_data).to eq(data)
            end
            # it 'encrypts data' do
            #     EncryptionService.new(sender, receiver, 500).call

            #     expect(sender_account.balance).to eq(500)
            #     expect(receiver_account.balance).to eq(500)
            # end
        end

        context 'involving user data' do
            it 'automatically encrypts user data'
            it 'automatically decrypts user data'
            it 'still finds correct user with encrypted data'
        end
        
    #end
end