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
    shared_context "involving user data" do
      before do
        @user = User.new(:first_name => "John", 
          :last_name => "Doe",
          :email => "johndoe@tamu.edu"
        )
      end
    end
    describe 'automatically encrypts' do
      include_context "involving user data"
      it 'first name' do
        expect(@user.read_attribute("first_name".to_sym)).not_to eq("John")
      end
      it 'last name' do
        expect(@user.read_attribute("last_name".to_sym)).not_to eq("Doe")
      end
      it 'email' do
        expect(@user.read_attribute("email".to_sym)).not_to eq("johndoe@tamu.edu")
      end
    end
    describe 'automatically decrypts' do
      include_context "involving user data"
      it 'first name' do
        expect(@user.first_name).to eq("John")
      end
      it 'last name' do
        expect(@user.last_name).to eq("Doe")
      end
      it 'email' do
        expect(@user.email).to eq("johndoe@tamu.edu")
      end
    end
    describe 'still finds correct user with encrypted' do
      include_context "involving user data"
      @user.save
      it 'first name' do
        expect(User.find_by first_name: 'John').to eq(@user)
      end
      it 'last name' do
        expect(User.find_by last_name: 'Doe').to eq(@user)
      end
      it 'email' do
        expect(User.find_by email: 'johndoe@tamu.edu').to eq(@user)
      end
      @user.destroy
    end
end
      # it 'still finds correct user with encrypted data' do
      #   @user.save
      #   expect(User.find_by first_name: 'John').to eq(@user)
      #   expect(User.find_by last_name: 'Doe').to eq(@user)
      #   expect(User.find_by email: 'johndoe@tamu.edu').to eq(@user)
      #   @user.destroy
      # end