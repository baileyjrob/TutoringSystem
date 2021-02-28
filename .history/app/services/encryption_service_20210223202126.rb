class EncryptionService
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

            write_attribute(attribute, EncryptionService.encrypt(value))
          end

          define_method(attribute) do
            # value = self.public_send("encrypted_#{attribute}".to_sym)
            value = read_attribute(attribute)
            EncryptionService.decrypt(value) if value.present?
          end

          define_method("find_by_#{attribute}") do |value, *args|
            puts("Verify that entering overloaded method")
            return self.find_by(attribute: EncryptionService.encrypt(value))
          end
        end
      end
    end
  end
  KEY = ActiveSupport::KeyGenerator.new(
    ENV.fetch('SECRET_KEY_BASE')
  ).generate_key(
    ENV.fetch('ENCRYPTION_SERVICE_SALT'),
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
