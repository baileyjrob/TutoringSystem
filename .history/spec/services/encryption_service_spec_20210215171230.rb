require 'rails_helper'

RSpec.describe EncryptionService, type: :model do
  #describe 'Encryption and Decryption' do

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
    end
    before do
      @user = User.new(:uin => 111111111, 
        :first_name => "John", 
        :last_name => "Doe",
        :email => "johndoe@tamu.edu"
      )
    end
    context 'involving user data' do
      it 'automatically encrypts user data' do
        expect(@user.read_attribute("uin".to_sym)).not_to eq(111111111)
        expect(@user.read_attribute("first_name".to_sym)).not_to eq("John")
        expect(@user.read_attribute("last_name".to_sym)).not_to eq("Doe")
        expect(@user.read_attribute("email".to_sym)).not_to eq("johndoe@tamu.edu")
      end
      it 'automatically decrypts user data'
      it 'still finds correct user with encrypted data'
    end

    context 'joins' do
      it 'maintains encryption as foreign keys'
      it 'correctly joins at join tables'
      it 'recognizes nonexistant joins'
    end
      
  #end
end