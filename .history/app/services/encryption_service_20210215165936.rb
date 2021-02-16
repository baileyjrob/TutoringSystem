module Encryptable
  extend ActiveSupport::Concern

  class_methods do
    def attr_encrypted(*attributes)
      attributes.each do |attribute|
        define_method("#{attribute}=".to_sym) do |value|
          return if value.nil?
      
          # self.public_send(
          #     "encrypted_#{attribute}=".to_sym,
          #     EncryptionService.encrypt(value)
          # )
          self.write_attribute(attribute, EncryptionService.encrypt(value))
        end

        define_method(attribute) do
          #value = self.public_send("encrypted_#{attribute}".to_sym)
          value = self.public_send("#{attribute}".to_sym)
          EncryptionService.decrypt(value) if value.present?
        end
      end
    end
  end
end

class EncryptionService
  KEY = ActiveSupport::KeyGenerator.new(
    ENV.fetch("SECRET_KEY_BASE")
  ).generate_key(
    ENV.fetch("ENCRYPTION_SERVICE_SALT"),
    ActiveSupport::MessageEncryptor.key_len
  ).freeze

  private_constant :KEY

  delegate :encrypt_and_sign, :decrypt_and_verify, to: :encryptor

  def self.encrypt(value)
    new.encrypt_and_sign(value)
  end

  def self.decrypt(value)
    new.decrypt_and_verify(value)
  end

  private

  def encryptor
    ActiveSupport::MessageEncryptor.new(KEY)
  end
end